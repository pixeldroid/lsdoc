package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.FunctionInfo;
    import pixeldroid.lsdoc.models.ParamInfo;
    import pixeldroid.lsdoc.models.TemplateType;
    import pixeldroid.lsdoc.models.TypeInfo;

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

        private static function getTemplateType(templateTypes:TemplateType):Dictionary.<String,Object>
        {
            var tt:Dictionary.<String,Object> = {
                'type' : templateTypes.typeString,
            };

            var item_types:Vector.<Dictionary.<String,Object>> = [];

            for each(var item:TemplateType in templateTypes.itemTypes)
                item_types.push(getTemplateType(item));

            tt['item_types'] = item_types;

            return tt;
        }

        private static function getOneParameter(paramInfo:ParamInfo):Dictionary.<String,Object>
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
                param['template_types'] = getTemplateType(paramInfo.templateTypes);

            return param;
        }

        private static function getOneMethod(methodInfo:FunctionInfo):Dictionary.<String,Object>
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

                for each(var p:ParamInfo in methodInfo.parameters)
                    pList.push(getOneParameter(p));

                method['parameters'] = pList;
            }

            if (methodInfo.templateTypes)
                method['template_types'] = getTemplateType(methodInfo.templateTypes);

            return method;
        }

        private static function getMethods(methodList:Vector.<FunctionInfo>):Vector.<Dictionary.<String,Object>>
        {
            var methods:Vector.<Dictionary.<String,Object>> = [];

            for each(var m:FunctionInfo in methodList)
            {
                if (m.methodAttributes.contains('private'))
                    continue;

                methods.push(getOneMethod(m));
            }

            return methods;
        }

        private static function getDelegateInfo(typeInfo:TypeInfo):FunctionInfo
        {
            var attr:Vector.<String> = typeInfo.classAttributes.concat(['delegate']);

            var f:FunctionInfo = new FunctionInfo();
            f.docString = typeInfo.docString;
            f.methodAttributes = attr;
            f.name = typeInfo.name;
            f.returnTypeString = typeInfo.delegateReturnTypeString;

            if (typeInfo.delegateTypeStrings.length > 0)
            {
                var params:Vector.<ParamInfo> = [];
                var p:ParamInfo;
                var i:Number = 1;
                for each(var paramType:String in typeInfo.delegateTypeStrings)
                {
                    p = new ParamInfo();
                    p.name = 'param' +(i++);
                    p.typeString = paramType;
                    // FIXME: p.templateTypes cannot be set because loomlib does not carry delegate template type info
                    params.push(p);
                }

                f.parameters = params;
            }

            return f;
        }

        private static function getTypePage(typeInfo:TypeInfo, moduleInfo:ModuleInfo):Vector.<String>
        {
            var result:Vector.<String> = [];
            var typeList:Vector.<TypeInfo> = moduleInfo.types;

            var page:Dictionary.<String,Object> = {
                'layout' : 'type',
                'name'   : typeInfo.name,
                'module' : typeInfo.packageString,
                'type'   : typeInfo.construct,
            };

            if (typeInfo.classAttributes.length > 0)
                page['type_attributes'] = typeInfo.classAttributes;

            setTypeRefs(page, 'implements', typeInfo.interfaceStrings);
            setTypeRefs(page, 'ancestors', ModuleInfo.getAncestors(typeInfo, typeList));
            setTypeRefs(page, 'descendants', ModuleInfo.getDescendants(typeInfo, typeList));

            if (typeInfo.constructor && !typeInfo.constructor.methodAttributes.contains('private'))
                page['constructor'] = getOneMethod(typeInfo.constructor);

            // if (typeInfo.fields.length > 0)
            //     page['fields'] = getFields(typeInfo.fields);

            // if (typeInfo.properties.length > 0)
            //     page['properties'] = getProperties(typeInfo.properties);

            if (typeInfo.methods.length > 0)
                page['methods'] = getMethods(typeInfo.methods);

            if (typeInfo.construct == 'DELEGATE')
                page['signature'] = getOneMethod(getDelegateInfo(typeInfo));

            // typeInfo.metainfo

            var pageJson:Json = Json.fromObject(page);

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }


        private var typeInfo:TypeInfo;
        private var moduleInfo:ModuleInfo;

        public var lines:Vector.<String>;


        public function GenerateTypePage(typeInfo:TypeInfo, moduleInfo:ModuleInfo)
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
