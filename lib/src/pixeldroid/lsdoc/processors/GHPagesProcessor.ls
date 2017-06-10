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


    public class GHPagesProcessor implements LSDocProcessor
    {
        private static const logName:String = GHPagesProcessor.getTypeName();
        private var _context:ProcessingContext;


        public function initialize(context:ProcessingContext):void
        {
            _context = context;

            // var genInfo:GenerateInfo = new GenerateInfo(_context);
            // genInfo.addTaskStateCallback(TaskState.COMPLETED, onGenerateInfoComplete);
            // addTask(genInfo);

            // writeLines = new WriteLines(_context);
            // addTask(writeLines);
        }

        public function get context():ProcessingContext { return _context; }

        public function execute(lsdoc:LSDoc, opts:Dictionary):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];
            var outDir:String = opts.fetch('output-dir', 'docs').toString();
            var templateDir:String = opts.fetch('template-dir', 'doc-template').toString();
            var apiDir:String = FilePath.join(outDir, opts.fetch('api-dir', '_api'));
            var examplesSrc:String = FilePath.join(outDir, opts.fetch('examples-src', 'my-examples'));
            var examplesDir:String = FilePath.join(outDir, opts.fetch('examples-dir', '_examples'));
            var guidesSrc:String = FilePath.join(outDir, opts.fetch('guides-src', 'my-guides'));
            var guidesDir:String = FilePath.join(outDir, opts.fetch('guides-dir', '_guides'));

            // TODO: start using tasks

            err = err.concat(removeOldFiles(outDir));
            err = err.concat(installTemplateFiles(templateDir, outDir));
            err = err.concat(generateApiFiles(apiDir));
            err = err.concat(copyExamplesFiles(examplesSrc, examplesDir));
            err = err.concat(copyGuidesFiles(guidesSrc, guidesDir));

            return err;
        }


        private function removeOldFiles(dir:String):Vector.<LSDocError>
        {
            Log.info(logName, function():String{ return 'removeOldFiles from: "' +dir +'"'; });
            var err:Vector.<LSDocError> = [];
            var recursive:Boolean = true;

            if (Path.dirExists(dir) && !Path.removeDir(dir))
            {
                Log.error(logName, function():String{ return 'folder deletion failed'; });
                err.push(LSDocError.deleteFail('path: ' +dir));
                return err;
            }

            Path.makeDir(dir);
            if (!Path.dirExists(dir))
            {
                Log.error(logName, function():String{ return 'folder creation failed'; });
                err.push(LSDocError.dirFail('path: ' +dir));
                return err;
            }

            return err;
        }

        private function installTemplateFiles(src:String, dir:String):Vector.<LSDocError>
        {
            Log.info(logName, function():String{ return 'installTemplateFiles to: "' +dir +'"'; });
            var err:Vector.<LSDocError> = [];

            Path.makeDir(dir);
            if (!Path.dirExists(dir))
            {
                Log.error(logName, function():String{ return 'folder creation failed'; });
                err.push(LSDocError.dirFail('path: ' +dir));
                return err;
            }

            return err;
        }

        private function generateApiFiles(dir:String):Vector.<LSDocError>
        {
            Log.info(logName, function():String{ return 'generateApiFiles into: "' +dir +'"'; });
            var err:Vector.<LSDocError> = [];
            return err;
        }

        private function copyExamplesFiles(src:String, dir:String):Vector.<LSDocError>
        {
            Log.info(logName, function():String
            {
                return [
                    'copyExamplesFiles',
                    'from: "' +src +'"',
                    'into: "' +dir +'"'
                ].join('\n');
            });

            var err:Vector.<LSDocError> = [];
            return err;
        }

        private function copyGuidesFiles(src:String, dir:String):Vector.<LSDocError>
        {
            Log.info(logName, function():String
            {
                return [
                    'copyGuidesFiles',
                    'from: "' +src +'"',
                    'into: "' +dir +'"'
                ].join('\n');
            });

            var err:Vector.<LSDocError> = [];
            return err;
        }
    }
}
