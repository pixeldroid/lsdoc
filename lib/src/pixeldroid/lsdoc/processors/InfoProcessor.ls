package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.info.WriteLibModule;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.util.Log;


    public class InfoProcessor extends SequentialTask implements LSDocProcessor
    {
        private static const logName:String = InfoProcessor.getTypeName();
        private var _context:ProcessingContext;


        public function initialize(context:ProcessingContext):void
        {
            Log.debug(logName, function():String{ return 'initializing..'; });

            _context = context;

            for each(var m:LibModule in _context.lsdoc.modules)
                addTask(new WriteLibModule(m, _context));

            Log.debug(logName, function():String{ return 'ready to process ' +numTasks +' modules'; });
        }

        public function get context():ProcessingContext { return _context; }

    }
}
