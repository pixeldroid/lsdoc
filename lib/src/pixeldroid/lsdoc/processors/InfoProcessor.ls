package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.GenerateInfo;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;

    import pixeldroid.platform.FilePath;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.Log;


    public class InfoProcessor extends SequentialTask implements LSDocProcessor
    {
        private static const logName:String = InfoProcessor.getTypeName();
        private static const fileName:String = 'docinfo';
        private var _context:ProcessingContext;
        private var genInfo:GenerateInfo;
        private var writeLines:WriteLines;


        public function initialize(context:ProcessingContext):void
        {
            Log.debug(logName, function():String{ return 'initializing..'; });
            _context = context;

            addTask(genInfo = new GenerateInfo(_context));
            addTask(writeLines = new WriteLines(_context));

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);

            Log.debug(logName, function():String{ return 'numTasks: ' +numTasks; });
        }

        public function get context():ProcessingContext { return _context; }


        private function handleSubTaskCompletion(task:Task):void
        {
            Log.debug(logName, function():String{ return 'handleSubTaskCompletion() ' +task; });

            if (task == genInfo)
            {
                Log.debug(logName, function():String{ return 'providing lines to the write lines task'; });
                writeLines.outfile = FilePath.join(_context.outDir, fileName);
                writeLines.lines = (task as GenerateInfo).lines;
                Log.debug(logName, function():String{ return 'lines assigned'; });
            }
        }

    }
}
