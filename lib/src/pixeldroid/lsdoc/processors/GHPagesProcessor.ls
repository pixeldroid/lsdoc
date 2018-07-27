package pixeldroid.lsdoc.processors
{
    import system.platform.Path;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.tasks.EnsureEmptyDirectory;
    import pixeldroid.lsdoc.processors.tasks.CopyFile;
    import pixeldroid.lsdoc.processors.tasks.CopyDirContents;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WriteUserConfig;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WritePackagePage;
    import pixeldroid.lsdoc.processors.tasks.ghpages.WriteTypePage;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.util.file.FilePath;
    import pixeldroid.util.log.Log;


    public class GHPagesProcessor extends SequentialTask implements LSDocProcessor
    {
        private static const logName:String = GHPagesProcessor.getTypeName();
        private var _context:ProcessingContext;


        public function initialize(context:ProcessingContext):void
        {
            _context = context;

            addTaskToEmptyOutputDir();
            addTaskToCopyDocSourceFiles();
            addTaskToGenerateApiDocs();
            addTaskToWriteUserConfig();
        }

        public function get context():ProcessingContext { return _context; }


        private function addTaskToEmptyOutputDir():void
        {
            addTask(new EnsureEmptyDirectory(_context.outPath, _context));
        }

        private function addTaskToCopyDocSourceFiles():void
        {
            var docsSrc:String = _context.getOption('docs-src', 'd', [null])[0];
            if (docsSrc)
            {
                var excludes:Vector.<String>;
                addTask(new CopyDirContents(docsSrc, _context.outPath, excludes, _context));
            }
        }

        private function addTaskToGenerateApiDocs():void
        {
            var apiDir:String = _context.getOption('api-dir', null, ['_api'])[0];
            var apiPath:String = FilePath.join(_context.outPath, apiDir);
            addTask(new EnsureEmptyDirectory(apiPath, _context));

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

        private function addTaskToWriteUserConfig():void
        {

            var configSrc:String = _context.getOption('config-src', 'c', [null])[0];
            if (!configSrc)
            {
                context.appendErrors([LSDocError.noDir('user config file not provided, unable to merge site config')]);
                return;
            }

            addTask(new WriteUserConfig(configSrc, FilePath.join(_context.outPath, '_config.yml'), _context));
        }

    }
}
