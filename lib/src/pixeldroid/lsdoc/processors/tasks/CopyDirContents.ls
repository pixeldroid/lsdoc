package pixeldroid.lsdoc.processors.tasks
{
    import system.platform.Path;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SingleTask;
    import pixeldroid.util.file.FileUtils;
    import pixeldroid.util.log.Log;


    public class CopyDirContents extends SingleTask
    {
        private static const logName:String = CopyDirContents.getTypeName();

        private var context:ProcessingContext;
        private var sourceDir:String;
        private var targetDir:String;
        private var excludes:Vector.<String>;


        public function CopyDirContents(sourceDir:String, targetDir:String, excludes:Vector.<String>, context:ProcessingContext)
        {
            this.context = context;
            this.sourceDir = sourceDir;
            this.targetDir = targetDir;
            this.excludes = excludes;
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

            if (!FileUtils.copyContents(sourceDir, targetDir, excludes))
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
