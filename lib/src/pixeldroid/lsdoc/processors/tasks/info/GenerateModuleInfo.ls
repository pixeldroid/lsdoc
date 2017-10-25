package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.log.Log;


    public class GenerateLibModule extends SingleTask
    {
        private static const logName:String = GenerateLibModule.getTypeName();
        private var module:LibModule;

        public var lines:Vector.<String>;


        public function GenerateLibModule(module:LibModule)
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


        private function getInfo(m:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];

            result.push(m);
            for each(var t:LibType in m.types)
                result.push(' ' +t);

            return result;
        }

    }
}
