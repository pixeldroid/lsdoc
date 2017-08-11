package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.ModuleInfo;
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
