package pixeldroid.lsdoc.processors.tasks
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GenerateInfo extends SingleTask
    {
        private static const logName:String = GenerateInfo.getTypeName();
        private var context:ProcessingContext;

        public var lines:Vector.<String>;


        public function GenerateInfo(context:ProcessingContext)
        {
            this.context = context;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask()'; });

            lines = getInfo(context.lsdoc);
            Log.debug(logName, function():String{ return 'generated ' +lines.length +' lines'; });

            complete();
        }


        private function getInfo(lsdoc:LSDoc):Vector.<String>
        {
            var lines:Vector.<String> = [];

            for each(var m:ModuleInfo in lsdoc.modules)
            {
                lines.push(m);
                for each(var t:TypeInfo in m.types) lines.push(' ' +t);
            }
            lines.push(lsdoc.numTypes +' total types');

            return lines;
        }

    }
}
