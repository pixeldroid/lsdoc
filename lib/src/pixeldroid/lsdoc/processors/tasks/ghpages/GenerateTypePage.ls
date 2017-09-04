package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.DocTag;
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
    import pixeldroid.platform.StringUtils;
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

        private static function getCopiedDocInfo(docTags:Vector.<DocTag>, defaultName:String, memberType:Type, moduleInfo:LibModule, cTags:Vector.<DocTag>, cStrings:Vector.<String>):Boolean
        {
            // @copy does not follow transitive references
            var foundSome:Boolean = false;
            var tags:Vector.<DocTag> = [];
            if (!DocTag.selectByTagName(docTags, 'copy', tags))
                return foundSome;

            var packageString:String;
            var memberName:String;
            var t:LibType;
            for each(var d:DocTag in tags)
            {
                packageString = StringUtils.before(d.value, '#');
                memberName = StringUtils.after(d.value, '#');
                if (!memberName)
                    memberName = defaultName;

                if (t = moduleInfo.fetchType(packageString))
                {
                    var dt:DocTag;
                    switch(memberType)
                    {
                        case TypeField:
                            var f:TypeField = t.getField(memberName);
                            if (!f) { break; }

                            foundSome = (f.docString || f.docTags);
                            if (f.docString) { cStrings.push(f.docString); }
                            if (f.docTags) { for each(dt in f.docTags) { cTags.push(dt); } }
                        break;

                        case TypeMethod:
                            var m:TypeMethod = t.getMethod(memberName);
                            if (!m) { break; }

                            foundSome = (m.docString || m.docTags);
                            if (m.docString) { cStrings.push(m.docString); }
                            if (m.docTags) { for each(dt in m.docTags) { cTags.push(dt); } }
                        break;

                        case TypeProperty:
                            var p:TypeProperty = t.getProperty(memberName);
                            if (!p) { break; }

                            foundSome = (p.docString || p.docTags);
                            if (p.docString) { cStrings.push(p.docString); }
                            if (p.docTags) { for each(dt in p.docTags) { cTags.push(dt); } }
                        break;
                    }
                }
            }

            return foundSome;
        }

        private static function getOneTag(tagInfo:DocTag):Dictionary.<String,Object>
        {
            var tag:Dictionary.<String,Object> = {
                'name'  : tagInfo.name,
                'value' : tagInfo.value,
            };

            return tag;
        }

        private static function getTags(tagList:Vector.<DocTag>):Vector.<Dictionary.<String,Object>>
        {
            var tags:Vector.<Dictionary.<String,Object>> = [];

            for each(var d:DocTag in tagList)
                tags.push(getOneTag(d));

            return tags;
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

        private static function getOneParameter(paramInfo:MethodParameter, tags:Vector.<DocTag>):Dictionary.<String,Object>
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

            for each(var t:DocTag in tags)
            {
                if (StringUtils.startsWith(t.value, paramInfo.name))
                {
                    param['description'] = t.value.substring(paramInfo.name.length + 1);
                    break;
                }
            }

            return param;
        }

        private static function getOneMethod(methodInfo:TypeMethod, moduleInfo:LibModule):Dictionary.<String,Object>
        {
            var method:Dictionary.<String,Object> = {
                'name'        : methodInfo.name,
                'attributes'  : methodInfo.attributes,
                'description' : methodInfo.docString,
                'type'        : methodInfo.returnTypeString,
            };

            var tags:Vector.<DocTag> = [];

            if (methodInfo.docTags.length > 0)
            {
                tags.clear();
                var strings:Vector.<String> = [];
                if (getCopiedDocInfo(methodInfo.docTags, methodInfo.name, TypeMethod, moduleInfo, tags, strings))
                {
                    method['description'] = strings.join('\n') +method['description'];
                    DocTag.selectByTagName(tags, 'param', methodInfo.docTags); // add any copied params to methodInfo
                }

                // collect non-param tags, adding to any copied tags
                if (DocTag.selectByTagName(methodInfo.docTags, 'param', tags, true))
                    method['tags'] = getTags(tags);
            }

            if (methodInfo.parameters.length > 0)
            {
                tags.clear();
                DocTag.selectByTagName(methodInfo.docTags, 'param', tags);

                var pList:Vector.<Dictionary.<String,Object>> = [];

                for each(var p:MethodParameter in methodInfo.parameters)
                    pList.push(getOneParameter(p, tags));

                method['parameters'] = pList;
            }

            if (methodInfo.templateTypes)
                method['template_types'] = getValueTemplate(methodInfo.templateTypes);

            if (methodInfo.isChainable)
                method['is_chainable'] = true;

            return method;
        }

        private static function getMethods(methodList:Vector.<TypeMethod>, moduleInfo:LibModule):Vector.<Dictionary.<String,Object>>
        {
            var methods:Vector.<Dictionary.<String,Object>> = [];

            for each(var m:TypeMethod in methodList)
            {
                if (m.attributes.contains('private'))
                    continue;

                methods.push(getOneMethod(m, moduleInfo));
            }

            return methods;
        }

        private static function getOneField(fieldInfo:TypeField, moduleInfo:LibModule):Dictionary.<String,Object>
        {
            var field:Dictionary.<String,Object> = {
                'name'        : fieldInfo.name,
                'attributes'  : fieldInfo.attributes,
                'description' : fieldInfo.docString,
                'type'        : fieldInfo.typeString,
            };

            if (fieldInfo.docTags.length > 0)
            {
                var tags:Vector.<DocTag> = [];
                var strings:Vector.<String> = [];

                if (getCopiedDocInfo(fieldInfo.docTags, fieldInfo.name, TypeField, moduleInfo, tags, strings))
                    field['description'] = strings.join('\n') +field['description'];

                field['tags'] = getTags(tags.concat(fieldInfo.docTags));
            }

            if (fieldInfo.templateTypes)
                field['template_types'] = getValueTemplate(fieldInfo.templateTypes);

            return field;
        }

        private static function getFields(fieldList:Vector.<TypeField>, moduleInfo:LibModule):Vector.<Dictionary.<String,Object>>
        {
            var fields:Vector.<Dictionary.<String,Object>> = [];

            for each(var f:TypeField in fieldList)
            {
                if (f.attributes.contains('private'))
                    continue;

                fields.push(getOneField(f, moduleInfo));
            }

            return fields;
        }

        private static function getOneProperty(propertyInfo:TypeProperty, moduleInfo:LibModule):Dictionary.<String,Object>
        {
            var property:Dictionary.<String,Object> = {
                'name'        : propertyInfo.name,
                'attributes'  : propertyInfo.attributes,
                'description' : propertyInfo.docString,
                'type'        : propertyInfo.typeString,
            };

            if (propertyInfo.docTags.length > 0)
            {
                var tags:Vector.<DocTag> = [];
                var strings:Vector.<String> = [];

                if (getCopiedDocInfo(propertyInfo.docTags, propertyInfo.name, TypeProperty, moduleInfo, tags, strings))
                    property['description'] = strings.join('\n') +property['description'];

                property['tags'] = getTags(tags.concat(propertyInfo.docTags));
            }

            if (propertyInfo.templateTypes)
                property['template_types'] = getValueTemplate(propertyInfo.templateTypes);

            if (propertyInfo.getter)
                property['getter'] = getOneMethod(propertyInfo.getter, moduleInfo);

            if (propertyInfo.setter)
                property['setter'] = getOneMethod(propertyInfo.setter, moduleInfo);

            if (propertyInfo.isReadOnly)
                property['is_read_only'] = true;

            return property;
        }

        private static function getProperties(propertyList:Vector.<TypeProperty>, moduleInfo:LibModule):Vector.<Dictionary.<String,Object>>
        {
            var properties:Vector.<Dictionary.<String,Object>> = [];

            for each(var p:TypeProperty in propertyList)
            {
                if (p.attributes.contains('private'))
                    continue;

                properties.push(getOneProperty(p, moduleInfo));
            }

            return properties;
        }

        private static function getDelegateInfo(typeInfo:LibType):TypeMethod
        {
            var m:TypeMethod = new TypeMethod();
            m.docString = typeInfo.docString;
            m.docTags = typeInfo.docTags;
            m.attributes = typeInfo.attributes.concat(['delegate']);
            m.name = typeInfo.name;
            m.returnTypeString = typeInfo.delegateReturnTypeString;

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
                    // Note: p.templateTypes cannot be set because loomlib does not carry delegate template type info
                    params.push(p);
                }

                m.parameters = params;
            }

            return m;
        }

        private static function getTypePage(typeInfo:LibType, moduleInfo:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];
            var typeList:Vector.<LibType> = moduleInfo.types;

            var page:Dictionary.<String,Object> = {
                'layout'      : 'type',
                'name'        : typeInfo.name,
                'description' : typeInfo.docString,
                'module'      : typeInfo.packageString,
                'type'        : typeInfo.construct,
            };

            if (typeInfo.attributes.length > 0)
                page['type_attributes'] = typeInfo.attributes;

            setTypeRefs(page, 'implements', typeInfo.interfaceStrings);
            setTypeRefs(page, 'ancestors', LibModule.getAncestors(typeInfo, moduleInfo));
            setTypeRefs(page, 'descendants', LibModule.getDescendants(typeInfo, moduleInfo));

            if (typeInfo.constructor && !typeInfo.constructor.attributes.contains('private'))
                page['constructor'] = getOneMethod(typeInfo.constructor, moduleInfo);

            if (typeInfo.docTags.length > 0)
                page['tags'] = getTags(typeInfo.docTags);

            if (typeInfo.fields.length > 0)
                page['fields'] = getFields(typeInfo.fields, moduleInfo);

            if (typeInfo.properties.length > 0)
                page['properties'] = getProperties(typeInfo.properties, moduleInfo);

            if (typeInfo.methods.length > 0)
                page['methods'] = getMethods(typeInfo.methods, moduleInfo);

            if (typeInfo.construct == 'DELEGATE')
                page['signature'] = getOneMethod(getDelegateInfo(typeInfo), moduleInfo);

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
