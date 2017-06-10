package pixeldroid.lsdoc.processors.tasks
{
    import system.platform.File;
    import system.platform.Path;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.platform.FilePath;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class WriteLines extends SingleTask
    {
        private static const logName:String = WriteLines.getTypeName();

        private var context:ProcessingContext;

        public var lines:Vector.<String>;
        public var outfile:String;


        public function WriteLines(context:ProcessingContext)
        {
            this.context = context;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask()'; });

            if (!lines)
            {
                context.appendErrors([LSDocError.writeFail('no lines provided.')]);
                fault('missing data to write file.');
                return;
            }

            if (!outfile)
            {
                context.appendErrors([LSDocError.writeFail('outfile not provided.')]);
                fault('missing name of file to write to.');
                return;
            }

            var errors:Vector.<LSDocError> = write(lines, outfile);
            if (errors.length > 0)
            {
                context.appendErrors(errors);
                fault('write unsuccessful.');
                return;
            }

            complete();
        }


        private function write(lines:Vector.<String>, outfile:String):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];
            var dir:String = FilePath.dirname(outfile);

            if (!Path.dirExists(dir))
            {
                Log.debug(logName, function():String{ return 'creating folder: "' +dir +'"'; });

                Path.makeDir(dir);
                if (!Path.dirExists(dir))
                {
                    Log.error(logName, function():String{ return 'folder creation failed'; });
                    err.push(LSDocError.dirFail('path: ' +dir));
                    return err;
                }
            }

            Log.debug(logName, function():String{ return 'writing results to file: "' +outfile +'"'; });

            if (!File.writeTextFile(outfile, lines.join('\n')))
            {
                Log.error(logName, function():String{ return 'file writing failed'; });
                err.push(LSDocError.writeFail('path: ' +outfile));
            }

            return err;
        }

    }
}
