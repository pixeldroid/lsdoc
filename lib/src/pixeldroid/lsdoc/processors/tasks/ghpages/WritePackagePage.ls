package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GeneratePackagePage;

    import pixeldroid.platform.FilePath;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.Log;


    public class WritePackagePage extends SequentialTask
    {
        private static const logName:String = WritePackagePage.getTypeName();
        private var genPackagePage:GeneratePackagePage;
        private var writeLines:WriteLines;


        public function WritePackagePage(apiPath:String, packageName:String, moduleInfo:ModuleInfo, context:ProcessingContext)
        {
            var packagePath:Vector.<String> = packageName.split('.');
            var fileName:String = packagePath.pop() +'.html'; // removes file name from packagePath

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(apiPath, packagePath, fileName);
            Log.debug(logName, function():String{ return 'WritePackagePage constructor() - outfile: "' +writeLines.outfile +'"'; });

            genPackagePage = new GeneratePackagePage(packageName, moduleInfo);

            addTask(genPackagePage);
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genPackagePage)
                writeLines.lines = (task as GeneratePackagePage).lines;
        }

    }
}
