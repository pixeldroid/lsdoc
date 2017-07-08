package pixeldroid.lsdoc.processors
{
    import system.platform.Path;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.tasks.EmptyDirectory;
    import pixeldroid.lsdoc.processors.tasks.CopyFiles;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GeneratePackagePages;

    import pixeldroid.platform.FilePath;
    import pixeldroid.task.SequentialTask;
    import pixeldroid.util.Log;


    public class GHPagesProcessor extends SequentialTask implements LSDocProcessor
    {
        private static const logName:String = GHPagesProcessor.getTypeName();
        private var _context:ProcessingContext;


        public function initialize(context:ProcessingContext):void
        {
            _context = context;

            addEmptyOutputDir();
            addInstallTemplates();
            addGenerateApiDocs();
            addCopyExamples();
            addCopyGuides();
        }

        public function get context():ProcessingContext { return _context; }


        private function addEmptyOutputDir():void
        {
            addTask(new EmptyDirectory(_context.outPath, _context));
        }

        private function addInstallTemplates():void
        {
            var templateSrc:String = _context.getOption('templates-src', 't', [null])[0];

            if (templateSrc)
            {
                addTask(new CopyFiles(templateSrc, _context.outPath, _context));
            }
            else
            {
                context.appendErrors([LSDocError.noDir('doc template directory not provided')]);
            }
        }

        private function addGenerateApiDocs():void
        {
            var apiDir:String = _context.getOption('api-dir', null, ['_api'])[0];
            var apiPath:String = FilePath.join(_context.outPath, apiDir);
            addTask(new GeneratePackagePages(apiPath, _context));
            // addTask(new GenerateTypePages(apiPath, _context));
        }

        private function addCopyHomePage():void
        {
            var indexSrc:String = _context.getOption('index-src', 'i', ['index.md'])[0];
            if (indexSrc)
            {
                addTask(new CopyFiles(indexSrc, _context.outPath, _context));
            }
        }

        private function addCopyExamples():void
        {
            var examplesSrc:String = _context.getOption('examples-src', 'e', [null])[0];
            if (examplesSrc)
            {
                var examplesDir:String = _context.getOption('examples-dir', null, ['_examples'])[0];
                var examplesPath:String = FilePath.join(_context.outPath, examplesDir);
                addTask(new CopyFiles(examplesSrc, examplesPath, _context));
            }
        }

        private function addCopyGuides():void
        {
            var guidesSrc:String = _context.getOption('guides-src', 'g', [null])[0];
            if (guidesSrc)
            {
                var guidesDir:String = _context.getOption('guides-dir', null, ['_guides'])[0];
                var guidesPath:String = FilePath.join(_context.outPath, guidesDir);
                addTask(new CopyFiles(guidesSrc, guidesPath, _context));
            }
        }

    }
}
