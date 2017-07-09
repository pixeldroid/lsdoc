package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GenerateModuleInfo extends SingleTask
    {
        private static const logName:String = GenerateModuleInfo.getTypeName();
        private var module:ModuleInfo;

        public var lines:Vector.<String>;


        public function GenerateModuleInfo(module:ModuleInfo)
        {
            this.module = module;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for module ' +module.name; });

            lines = getInfo(module);
            Log.debug(logName, function():String{ return 'generated ' +lines.length +' lines'; });

            complete();
        }


        private function getInfo(m:ModuleInfo):Vector.<String>
        {
            var result:Vector.<String> = [];

            result.push(m);
            for each(var t:TypeInfo in m.types)
                result.push(' ' +t);

            return result;
        }

    }
}
