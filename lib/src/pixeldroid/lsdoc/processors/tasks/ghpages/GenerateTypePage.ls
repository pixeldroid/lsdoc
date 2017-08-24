package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.lsdoc.models.MethodParameter;
    import pixeldroid.lsdoc.models.TypeField;
    import pixeldroid.lsdoc.models.TypeMethod;
    import pixeldroid.lsdoc.models.TypeProperty;
    import pixeldroid.lsdoc.models.ValueTemplate;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GenerateTypePage extends SingleTask
    {
        private static const logName:String = GenerateTypePage.getTypeName();
        private static var _yamlOptions:YamlPrinterOptions;

        private static function get yamlOptions():YamlPrinterOptions
        {
            if (!_yamlOptions)
            {
                _yamlOptions = YamlPrinterOptions.compact;
                _yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter
            }

            return _yamlOptions;
        }

        private static function toTypeRef(fullName:String):Dictionary.<String,Object>
        {
            var lastDot:Number = fullName.lastIndexOf('.');
            var typeRef:Dictionary.<String,Object> = {
                'name' : fullName.substring(lastDot+1, fullName.length),
                'module' : fullName.substring(0, lastDot),
            };

            return typeRef;
        }

        private static function setTypeRefs(page:Dictionary.<String,Object>, section:String, names:Vector.<String>)
        {
            if (names.length == 0)
                return;

            var typeRefs:Vector.<Dictionary.<String,Object>> = [];

            for each(var fullName:String in names)
                typeRefs.push(toTypeRef(fullName));

            page[section] = typeRefs;
        }

        private static function getValueTemplate(templateTypes:ValueTemplate):Dictionary.<String,Object>
        {
            var tt:Dictionary.<String,Object> = {
                'type' : templateTypes.typeString,
            };

            var item_types:Vector.<Dictionary.<String,Object>> = [];

            for each(var item:ValueTemplate in templateTypes.itemTypes)
                item_types.push(getValueTemplate(item));

            tt['item_types'] = item_types;

            return tt;
        }

        private static function getOneParameter(paramInfo:MethodParameter):Dictionary.<String,Object>
        {
            var param:Dictionary.<String,Object> = {
                'name' : paramInfo.name,
                'type' : paramInfo.typeString,
            };

            if (paramInfo.hasDefault)
                param['default_value'] = paramInfo.defaultValue;

            if (paramInfo.isVarArgs)
                param['is_var_args'] = true;

            if (paramInfo.templateTypes)
                param['template_types'] = getValueTemplate(paramInfo.templateTypes);

            return param;
        }

        private static function getOneMethod(methodInfo:TypeMethod):Dictionary.<String,Object>
        {
            var method:Dictionary.<String,Object> = {
                'name'        : methodInfo.name,
                'attributes'  : methodInfo.methodAttributes,
                'description' : methodInfo.docString,
                'type'        : methodInfo.returnTypeString,
            };

            if (methodInfo.parameters.length > 0)
            {
                var pList:Vector.<Dictionary.<String,Object>> = [];

                for each(var p:MethodParameter in methodInfo.parameters)
                    pList.push(getOneParameter(p));

                method['parameters'] = pList;
            }

            if (methodInfo.templateTypes)
                method['template_types'] = getValueTemplate(methodInfo.templateTypes);

            return method;
        }

        private static function getMethods(methodList:Vector.<TypeMethod>):Vector.<Dictionary.<String,Object>>
        {
            var methods:Vector.<Dictionary.<String,Object>> = [];

            for each(var m:TypeMethod in methodList)
            {
                if (m.methodAttributes.contains('private'))
                    continue;

                methods.push(getOneMethod(m));
            }

            return methods;
        }

        private static function getOneField(fieldInfo:TypeField):Dictionary.<String,Object>
        {
            var field:Dictionary.<String,Object> = {
                'name'        : fieldInfo.name,
                'attributes'  : fieldInfo.fieldAttributes,
                'description' : fieldInfo.docString,
                'type'        : fieldInfo.typeString,
            };

            if (fieldInfo.templateTypes)
                field['template_types'] = getValueTemplate(fieldInfo.templateTypes);

            return field;
        }

        private static function getFields(fieldList:Vector.<TypeField>):Vector.<Dictionary.<String,Object>>
        {
            var fields:Vector.<Dictionary.<String,Object>> = [];

            for each(var f:TypeField in fieldList)
            {
                if (f.fieldAttributes.contains('private'))
                    continue;

                fields.push(getOneField(f));
            }

            return fields;
        }

        private static function getOneProperty(propertyInfo:TypeProperty):Dictionary.<String,Object>
        {
            var property:Dictionary.<String,Object> = {
                'name'        : propertyInfo.name,
                'attributes'  : propertyInfo.propertyAttributes,
                'description' : propertyInfo.docString,
                'type'        : propertyInfo.typeString,
            };

            if (propertyInfo.templateTypes)
                property['template_types'] = getValueTemplate(propertyInfo.templateTypes);

            if (propertyInfo.getter)
                property['getter'] = getOneMethod(propertyInfo.getter);

            if (propertyInfo.setter)
                property['setter'] = getOneMethod(propertyInfo.setter);

            return property;
        }

        private static function getProperties(propertyList:Vector.<TypeProperty>):Vector.<Dictionary.<String,Object>>
        {
            var properties:Vector.<Dictionary.<String,Object>> = [];

            for each(var p:TypeProperty in propertyList)
            {
                if (p.propertyAttributes.contains('private'))
                    continue;

                properties.push(getOneProperty(p));
            }

            return properties;
        }

        private static function getDelegateInfo(typeInfo:LibType):TypeMethod
        {
            var attr:Vector.<String> = typeInfo.classAttributes.concat(['delegate']);

            var f:TypeMethod = new TypeMethod();
            f.docString = typeInfo.docString;
            f.methodAttributes = attr;
            f.name = typeInfo.name;
            f.returnTypeString = typeInfo.delegateReturnTypeString;

            if (typeInfo.delegateTypeStrings.length > 0)
            {
                var params:Vector.<MethodParameter> = [];
                var p:MethodParameter;
                var i:Number = 1;
                for each(var paramType:String in typeInfo.delegateTypeStrings)
                {
                    p = new MethodParameter();
                    p.name = 'param' +(i++);
                    p.typeString = paramType;
                    // FIXME: p.templateTypes cannot be set because loomlib does not carry delegate template type info
                    params.push(p);
                }

                f.parameters = params;
            }

            return f;
        }

        private static function getTypePage(typeInfo:LibType, moduleInfo:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];
            var typeList:Vector.<LibType> = moduleInfo.types;

            var page:Dictionary.<String,Object> = {
                'layout' : 'type',
                'name'   : typeInfo.name,
                'module' : typeInfo.packageString,
                'type'   : typeInfo.construct,
            };

            if (typeInfo.classAttributes.length > 0)
                page['type_attributes'] = typeInfo.classAttributes;

            setTypeRefs(page, 'implements', typeInfo.interfaceStrings);
            setTypeRefs(page, 'ancestors', LibModule.getAncestors(typeInfo, typeList));
            setTypeRefs(page, 'descendants', LibModule.getDescendants(typeInfo, typeList));

            if (typeInfo.constructor && !typeInfo.constructor.methodAttributes.contains('private'))
                page['constructor'] = getOneMethod(typeInfo.constructor);

            if (typeInfo.fields.length > 0)
                page['fields'] = getFields(typeInfo.fields);

            if (typeInfo.properties.length > 0)
                page['properties'] = getProperties(typeInfo.properties);

            if (typeInfo.methods.length > 0)
                page['methods'] = getMethods(typeInfo.methods);

            if (typeInfo.construct == 'DELEGATE')
                page['signature'] = getOneMethod(getDelegateInfo(typeInfo));

            // typeInfo.metainfo

            var pageJson:Json = Json.fromObject(page);

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }


        private var typeInfo:LibType;
        private var moduleInfo:LibModule;

        public var lines:Vector.<String>;


        public function GenerateTypePage(typeInfo:LibType, moduleInfo:LibModule)
        {
            this.typeInfo = typeInfo;
            this.moduleInfo = moduleInfo;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for ' +typeInfo; });

            lines = GenerateTypePage.getTypePage(typeInfo, moduleInfo);

            typeInfo = null;
            moduleInfo = null;

            complete();
        }

    }
}
