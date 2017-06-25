package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.util.Log;


    public class GenerateApiFiles extends SequentialTask
    {
        private static const logName:String = GenerateApiFiles.getTypeName();
        private var context:ProcessingContext;
        private var apiPath:String;

        public var lines:Vector.<String>;


        public function GenerateApiFiles(apiPath:String, context:ProcessingContext)
        {
            this.apiPath = apiPath;
            this.context = context;
        }

    }
}
