package pixeldroid.lsdoc.processors
{
    import system.platform.Path;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.tasks.EmptyDirectory;
    import pixeldroid.lsdoc.processors.tasks.CopyFile;
    import pixeldroid.lsdoc.processors.tasks.CopyDirContents;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WriteSiteConfig;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WritePackagePage;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WriteTypePage;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.util.FilePath;
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
            addMergeSiteConfig();
            addCopyHomePage();
            addCopyExamples();
            addCopyGuides();
            addGenerateApiDocs();
        }

        public function get context():ProcessingContext { return _context; }


        private function addEmptyOutputDir():void
        {
            addTask(new EmptyDirectory(_context.outPath, _context));
        }

        private function addInstallTemplates():void
        {
            var templateSrc:String = _context.getOption('templates-src', 't', [null])[0];
            if (!templateSrc)
            {
                context.appendErrors([LSDocError.noDir('doc template directory not provided, unable to install templates')]);
                return;
            }

            var excludes:Vector.<String> = [ FilePath.join(templateSrc, 'ghpages.config') ];
            addTask(new CopyDirContents(templateSrc, _context.outPath, excludes, _context));
        }

        private function addMergeSiteConfig():void
        {
            var templateSrc:String = _context.getOption('templates-src', 't', [null])[0];
            if (!templateSrc)
            {
                context.appendErrors([LSDocError.noDir('doc template directory not provided, unable to merge site config')]);
                return;
            }

            var templateConfigPath:String = FilePath.join(templateSrc, 'ghpages.config');
            var userConfigPath:String = _context.getOption('config-src', 'c', ['lsdoc.config'])[0];

            addTask(new WriteSiteConfig(templateConfigPath, userConfigPath, FilePath.join(_context.outPath, '_config.yml'), _context));
        }

        private function addCopyHomePage():void
        {
            var indexSrc:String = _context.getOption('index-src', 'i', ['index.md'])[0];
            if (indexSrc)
            {
                var filename:String = FilePath.basename(indexSrc);
                addTask(new CopyFile(indexSrc, FilePath.join(_context.outPath, filename), _context));
            }
        }

        private function addCopyExamples():void
        {
            var examplesSrc:String = _context.getOption('examples-src', 'e', [null])[0];
            if (examplesSrc)
            {
                var examplesDir:String = _context.getOption('examples-dir', null, ['_examples'])[0];
                var examplesPath:String = FilePath.join(_context.outPath, examplesDir);
                var excludes:Vector.<String>;
                addTask(new CopyDirContents(examplesSrc, examplesPath, excludes, _context));
            }
        }

        private function addCopyGuides():void
        {
            var guidesSrc:String = _context.getOption('guides-src', 'g', [null])[0];
            if (guidesSrc)
            {
                var guidesDir:String = _context.getOption('guides-dir', null, ['_guides'])[0];
                var guidesPath:String = FilePath.join(_context.outPath, guidesDir);
                var excludes:Vector.<String>;
                addTask(new CopyDirContents(guidesSrc, guidesPath, excludes, _context));
            }
        }

        private function addGenerateApiDocs():void
        {
            var apiDir:String = _context.getOption('api-dir', null, ['_api'])[0];
            var apiPath:String = FilePath.join(_context.outPath, apiDir);
            var packages:Vector.<String>;

            for each(var m:LibModule in context.lsdoc.modules)
            {
                // package pages
                packages = LibModule.getPackages(m);

                for each(var p:String in packages)
                    addTask(new WritePackagePage(apiPath, p, m, context));

                // type pages
                for each(var t:LibType in m.types)
                    addTask(new WriteTypePage(apiPath, t, m, context));
            }
        }

    }
}
