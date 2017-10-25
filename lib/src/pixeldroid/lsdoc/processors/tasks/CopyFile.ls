package pixeldroid.lsdoc.processors.tasks
{
    import system.platform.Path;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.log.Log;
    import pixeldroid.util.file.FilePath;
    import pixeldroid.util.file.FileUtils;


    public class CopyFile extends SingleTask
    {
        private static const logName:String = CopyFile.getTypeName();

        private var context:ProcessingContext;
        private var sourceFile:String;
        private var targetFile:String;


        public function CopyFile(src:String, dst:String, context:ProcessingContext)
        {
            this.context = context;
            this.sourceFile = src;
            this.targetFile = dst;
        }


        override protected function performTask():void
        {
            if (!File.fileExists(sourceFile))
            {
                Log.error(logName, function():String{ return 'no source file found'; });
                context.appendErrors([LSDocError.noDir('could not find source file: ' +sourceFile)]);
                fault('unable to copy file.');
                return;
            }

            if (!Path.dirExists(FilePath.dirname(targetFile)))
            {
                Log.error(logName, function():String{ return 'no target directory found'; });
                context.appendErrors([LSDocError.noDir('could not find target directory: ' +FilePath.dirname(targetFile))]);
                fault('unable to copy file.');
                return;
            }

            Log.debug(logName, function():String { return 'performTask() copying from "' +sourceFile +'" to "' +targetFile +'"'; });

            if (!File.copy(sourceFile, targetFile))
            {
                Log.error(logName, function():String{ return 'copy failed'; });
                context.appendErrors([LSDocError.noDir('copy failed')]);
                fault('unable to copy file.');
                return;
            }

            complete();
        }

    }
}
