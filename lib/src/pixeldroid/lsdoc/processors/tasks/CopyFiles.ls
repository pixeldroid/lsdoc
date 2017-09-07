package pixeldroid.lsdoc.processors.tasks
{
    import system.platform.Path;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.platform.FileUtils;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class CopyFiles extends SingleTask
    {
        private static const logName:String = CopyFiles.getTypeName();

        private var context:ProcessingContext;
        private var sourceDir:String;
        private var targetDir:String;


        public function CopyFiles(src:String, dst:String, context:ProcessingContext)
        {
            this.context = context;
            this.sourceDir = src;
            this.targetDir = dst;
        }


        override protected function performTask():void
        {
            if (!Path.dirExists(sourceDir))
            {
                Log.error(logName, function():String{ return 'no source directory found'; });
                context.appendErrors([LSDocError.noDir('could not find source directory: ' +sourceDir)]);
                fault('unable to copy files.');
                return;
            }

            if (!Path.dirExists(targetDir))
            {
                Log.error(logName, function():String{ return 'no target directory found'; });
                context.appendErrors([LSDocError.noDir('could not find target directory: ' +targetDir)]);
                fault('unable to copy files.');
                return;
            }

            Log.debug(logName, function():String { return 'performTask() copying from "' +sourceDir +'" to "' +targetDir +'"'; });

            if (!FileUtils.copyContents(sourceDir, targetDir))
            {
                Log.error(logName, function():String{ return 'copy failed'; });
                context.appendErrors([LSDocError.noDir('copy failed')]);
                fault('unable to copy files.');
                return;
            }

            complete();
        }

    }
}
