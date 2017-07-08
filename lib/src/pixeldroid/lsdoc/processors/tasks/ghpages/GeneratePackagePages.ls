package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GeneratePackagePages extends SingleTask
    {
        private static const logName:String = GeneratePackagePages.getTypeName();
        private var context:ProcessingContext;
        private var apiPath:String;

        public var lines:Vector.<String>;


        public function GeneratePackagePages(apiPath:String, context:ProcessingContext)
        {
            this.apiPath = apiPath;
            this.context = context;
        }


        override protected function performTask():void
        {
            var packages:Vector.<String> = [];

            Log.debug(logName, function():String{ return 'performTask() - ready to create the following package indices:'; });
            for each(var m:ModuleInfo in context.lsdoc.modules)
            {
                trace(m.toString());
                packages = ModuleInfo.getPackages(m.types);

                for each(var p:String in packages)
                    makePackagePage(p, m);
            }

            complete();
        }


        private function makePackagePage(packageName:String, moduleInfo:ModuleInfo):void
        {
            Log.debug(logName, function():String{ return 'makePackagePage() - ' +packageName; });

            var module:String = packageName.split('.').pop();
            var page:Dictionary.<String,Object> = {
                'layout' : 'package',
                'module' : module,
                'submodules' : ModuleInfo.getSubpackages(moduleInfo.types, packageName),
                'enums' : getChildrenByConstruct(moduleInfo, packageName, DefinitionConstruct.ENUM),
                'structs' : getChildrenByConstruct(moduleInfo, packageName, DefinitionConstruct.STRUCT),
                'delegates' : getChildrenByConstruct(moduleInfo, packageName, DefinitionConstruct.DELEGATE),
                'classes' : getChildrenByConstruct(moduleInfo, packageName, DefinitionConstruct.CLASS),
                'interfaces' : getChildrenByConstruct(moduleInfo, packageName, DefinitionConstruct.INTERFACE),
            };

            var pageJson:Json = Json.fromObject(page);
            trace(YamlPrinter.print(pageJson));
        }

        private function getChildrenByConstruct(moduleInfo:ModuleInfo, packageName:String, construct:DefinitionConstruct):Vector.<Dictionary.<String,Object>>
        {
            var result:Vector.<Dictionary.<String,Object>> = [];
            var filteredTypes:Vector.<TypeInfo>;

            filteredTypes = ModuleInfo.getTypesByConstruct(moduleInfo.types, construct);
            filteredTypes = ModuleInfo.getTypesByPackage(filteredTypes, packageName);

            for each(var t:TypeInfo in filteredTypes)
            {
                result.push({
                    'name' : t.name,
                    'description' : t.docString,
                    'declaration' : t.sourceFile
                    });
            }
            trace(construct.toString() +'[', filteredTypes.join(', '), ']');

            return result;
        }

    }
}
