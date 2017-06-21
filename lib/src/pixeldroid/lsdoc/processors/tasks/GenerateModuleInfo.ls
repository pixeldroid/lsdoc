package pixeldroid.lsdoc.processors.tasks
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GenerateModuleInfo extends SingleTask
    {
        private static const logName:String = GenerateModuleInfo.getTypeName();
        private var context:ProcessingContext;
        private var module:ModuleInfo;

        public var lines:Vector.<String>;


        public function GenerateModuleInfo(module:ModuleInfo, context:ProcessingContext)
        {
            this.module = module;
            this.context = context;
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
            var lines:Vector.<String> = [];

            lines.push(m);
            for each(var t:TypeInfo in m.types)
                lines.push(' ' +t);

            return lines;
        }

    }
}
