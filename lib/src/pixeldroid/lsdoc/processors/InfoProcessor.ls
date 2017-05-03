package pixeldroid.lsdoc.processors
{
    import system.platform.File;
    import system.platform.Path;

    import pixeldroid.platform.FilePath;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.LSDocProcessor;

    import pixeldroid.util.Log;


    public class InfoProcessor implements LSDocProcessor
    {
        private static const logName:String = InfoProcessor.getTypeName();

        public function execute(lsdoc:LSDoc, opts:Dictionary):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];
            var lines:Vector.<String> = [];
            var outfile:String = FilePath.join(opts.fetch('output-dir', 'docs'), 'docinfo');

            for each(var m:ModuleInfo in lsdoc.modules)
            {
                lines.push(m);
                for each(var t:TypeInfo in m.types) lines.push(' ' +t);
            }
            lines.push(lsdoc.numTypes +'total types');

            err = err.concat(write(lines, outfile));

            return err;
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

            Log.info(logName, function():String{ return 'writing results to file: "' +outfile +'"'; });

            if (!File.writeTextFile(outfile, lines.join('\n')))
            {
                Log.error(logName, function():String{ return 'file writing failed'; });
                err.push(LSDocError.writeFail('path: ' +outfile));
            }

            return err;
        }

    }
}
