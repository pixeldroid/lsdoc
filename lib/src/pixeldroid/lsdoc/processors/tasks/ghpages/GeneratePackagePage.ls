package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.log.Log;


    public class GeneratePackagePage extends SingleTask
    {
        private static const logName:String = GeneratePackagePage.getTypeName();
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

        private static function getPackagePage(pkg:String, moduleInfo:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];
            var submodules:Vector.<String>;
            var memberTypes:Vector.<Dictionary.<String,Object>>;

            var page:Dictionary.<String,Object> = {
                'layout' : 'package',
                'module' : pkg,
            };

            if ((submodules = LibModule.getSubpackages(pkg, moduleInfo)).length > 0)
                page['submodules'] = submodules;

            if ((memberTypes = getMembersByConstruct(DefinitionConstruct.CLASS, pkg, moduleInfo)).length > 0)
                page['classes'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(DefinitionConstruct.DELEGATE, pkg, moduleInfo)).length > 0)
                page['delegates'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(DefinitionConstruct.ENUM, pkg, moduleInfo)).length > 0)
                page['enums'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(DefinitionConstruct.INTERFACE, pkg, moduleInfo)).length > 0)
                page['interfaces'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(DefinitionConstruct.STRUCT, pkg, moduleInfo)).length > 0)
                page['structs'] = memberTypes;

            var pageJson:Json = Json.fromObject(page);

            yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }

        private static function getMembersByConstruct(construct:DefinitionConstruct, pkg:String, module:LibModule):Vector.<Dictionary.<String,Object>>
        {
            var filteredTypes:Vector.<LibType>;
            var memberInfo:Dictionary.<String,Object>;
            var result:Vector.<Dictionary.<String,Object>> = [];

            filteredTypes = LibModule.selectTypesByConstruct(construct, module.types);
            filteredTypes = LibModule.selectTypesByPackage(pkg, filteredTypes);

            for each(var t:LibType in filteredTypes)
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


        private var packageName:String;
        private var moduleInfo:LibModule;

        public var lines:Vector.<String>;


        public function GeneratePackagePage(packageName:String, moduleInfo:LibModule)
        {
            this.packageName = packageName;
            this.moduleInfo = moduleInfo;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for ' +packageName; });

            lines = GeneratePackagePage.getPackagePage(packageName, moduleInfo);

            moduleInfo = null;

            complete();
        }

    }
}
