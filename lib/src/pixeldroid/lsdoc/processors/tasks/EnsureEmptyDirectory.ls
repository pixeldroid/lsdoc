package pixeldroid.lsdoc.processors.tasks
{
    import system.platform.Path;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.file.FileUtils;
    import pixeldroid.util.log.Log;


    public class EnsureEmptyDirectory extends SingleTask
    {
        private static const logName:String = EnsureEmptyDirectory.getTypeName();

        private var context:ProcessingContext;
        private var directory:String;


        public function EnsureEmptyDirectory(directory:String, context:ProcessingContext)
        {
            this.context = context;
            this.directory = directory;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() emptying directory "' +directory +'"'; });

            if (Path.dirExists(directory) && !FileUtils.remove(directory))
            {
                Log.error(logName, function():String{ return 'directory deletion failed'; });
                context.appendErrors([LSDocError.deleteFail('path: ' +directory)]);
                fault('unable to remove directory.');
                return;
            }

            Path.makeDir(directory);
            if (!Path.dirExists(directory))
            {
                Log.error(logName, function():String{ return 'directory creation failed'; });
                context.appendErrors([LSDocError.dirFail('path: ' +directory)]);
                fault('unable to create directory.');
                return;
            }

            complete();
        }

    }
}
