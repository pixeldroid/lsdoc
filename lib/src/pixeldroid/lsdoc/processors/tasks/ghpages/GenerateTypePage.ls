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
        private var typeInfo:TypeInfo;
        private var moduleInfo:ModuleInfo;

        public var description:String;
        public var lines:Vector.<String>;


        public function GenerateTypePage(typeInfo:TypeInfo, moduleInfo:ModuleInfo)
        {
            this.typeInfo = typeInfo;
            this.moduleInfo = moduleInfo;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for ' +typeInfo; });

            description = typeInfo.docString;
            lines = getTypePage(typeInfo, moduleInfo);

            complete();
        }


        private function getTypePage(typeInfo:TypeInfo, moduleInfo:ModuleInfo):Vector.<String>
        {
            var result:Vector.<String> = [];

            var page:Dictionary.<String,Object> = {
                'layout' : 'type',
                'name'   : typeInfo.name,
                'module' : typeInfo.packageString,
                'type'   : typeInfo.construct,
            };

            if (typeInfo.classAttributes.length > 0)
                page['type_attributes'] = typeInfo.classAttributes;

            var pageJson:Json = Json.fromObject(page);

            var yamlOptions:YamlPrinterOptions = YamlPrinterOptions.compact;
            yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }

    }
}
