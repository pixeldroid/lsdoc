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

        private static function write(lines:Vector.<String>, outfile:String, overwrite:Boolean = true):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];
            var dir:String = FilePath.dirname(outfile);

            if (!Path.dirExists(dir))
            {
                Log.debug(logName, function():String{ return 'creating directory: "' +dir +'"'; });
                if (!createDir(dir, err))
                    return err;
            }

            Log.debug(logName, function():String{ return 'writing results to file: "' +outfile +'"'; });
            var contents:String = lines.join('\n');

            if (File.fileExists(outfile) && !overwrite)
            {
                Log.debug(logName, function():String{ return 'appending to file: "' +outfile +'"'; });
                if (!appendFile(outfile, contents, err))
                    return err;
            }
            else
            {
                Log.debug(logName, function():String{ return 'creating file: "' +outfile +'"'; });
                if (!writeFile(outfile, contents, err))
                    return err;
            }

            return err;
        }

        private static function createDir(dir:String, err:Vector.<LSDocError>):Boolean
        {
            Path.makeDir(dir);

            if (Path.dirExists(dir))
                return true;
            else
            {
                Log.error(logName, function():String{ return 'directory creation failed'; });
                err.push(LSDocError.dirFail('path: ' +dir));
                return false;
            }
        }

        private static function writeFile(file:String, contents:String, err:Vector.<LSDocError>):Boolean
        {
            if (File.writeTextFile(file, contents))
                return true;
            else
            {
                Log.error(logName, function():String{ return 'file writing failed'; });
                err.push(LSDocError.writeFail('path: ' +file));
                return false;
            }
        }

        private static function appendFile(file:String, contents:String, err:Vector.<LSDocError>):Boolean
        {
            // File has no append operation, so we read and concat and re-write
            var prepend:String = File.loadTextFile(file);
            prepend = (prepend && prepend.length > 0) ? prepend +'\n' : '';

            return writeFile(file, prepend +contents, err);
        }


        private var context:ProcessingContext;

        public var overwrite:Boolean = true;
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

            var errors:Vector.<LSDocError> = WriteLines.write(lines, outfile, overwrite);
            if (errors.length > 0)
            {
                context.appendErrors(errors);
                fault('write unsuccessful.');
                return;
            }

            complete();
        }

    }
}
