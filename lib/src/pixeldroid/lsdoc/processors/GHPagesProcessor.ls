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

            addTaskToEmptyApiDir();
            addTaskToGenerateApiDocs();
        }

        public function get context():ProcessingContext { return _context; }


        private function addTaskToEmptyApiDir():void
        {
            var apiDir:String = _context.getOption('api-dir', null, ['_api'])[0];
            var apiPath:String = FilePath.join(_context.outPath, apiDir);
            addTask(new EnsureEmptyDirectory(apiPath, _context));
        }

        private function addTaskToGenerateApiDocs():void
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
