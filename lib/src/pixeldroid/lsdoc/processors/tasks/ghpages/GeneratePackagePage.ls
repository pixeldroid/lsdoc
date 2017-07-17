package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GeneratePackagePage extends SingleTask
    {
        private static const logName:String = GeneratePackagePage.getTypeName();
        private var packageName:String;
        private var moduleInfo:ModuleInfo;

        public var lines:Vector.<String>;


        public function GeneratePackagePage(packageName:String, moduleInfo:ModuleInfo)
        {
            this.packageName = packageName;
            this.moduleInfo = moduleInfo;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for ' +packageName; });

            lines = getPackagePage(packageName, moduleInfo);

            complete();
        }


        private function getPackagePage(pkg:String, moduleInfo:ModuleInfo):Vector.<String>
        {
            var result:Vector.<String> = [];
            var types:Vector.<TypeInfo> = moduleInfo.types;
            var submodules:Vector.<String>;
            var memberTypes:Vector.<Dictionary.<String,Object>>;

            var page:Dictionary.<String,Object> = {
                'layout' : 'package',
                'module' : pkg,
            };

            if ((submodules = ModuleInfo.getSubpackages(types, pkg)).length > 0)
                page['submodules'] = submodules;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.CLASS)).length > 0)
                page['classes'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.DELEGATE)).length > 0)
                page['delegates'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.ENUM)).length > 0)
                page['enums'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.INTERFACE)).length > 0)
                page['interfaces'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.STRUCT)).length > 0)
                page['structs'] = memberTypes;

            var pageJson:Json = Json.fromObject(page);

            var yamlOptions:YamlPrinterOptions = YamlPrinterOptions.compact;
            yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }

        private function getMembersByConstruct(types:Vector.<TypeInfo>, pkg:String, construct:DefinitionConstruct):Vector.<Dictionary.<String,Object>>
        {
            var filteredTypes:Vector.<TypeInfo>;
            var memberInfo:Dictionary.<String,Object>;
            var result:Vector.<Dictionary.<String,Object>> = [];

            filteredTypes = ModuleInfo.getTypesByConstruct(types, construct);
            filteredTypes = ModuleInfo.getTypesByPackage(filteredTypes, pkg);

            for each(var t:TypeInfo in filteredTypes)
            {
                memberInfo = {
                    'name' : t.name,
                    'declaration' : t.sourceFile
                };

                if (t.docString.length > 0)
                    memberInfo['description'] = t.docString;

                result.push(memberInfo);
            }

            return result;
        }

    }
}
