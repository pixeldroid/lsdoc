package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.LibModule;
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


        public function WritePackagePage(apiPath:String, packageName:String, moduleInfo:LibModule, context:ProcessingContext)
        {
            var packagePath:Vector.<String> = packageName.split('.');
            var fileName:String = packagePath.pop() +'.html'; // removes file name from packagePath

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(apiPath, packagePath, fileName);

            genPackagePage = new GeneratePackagePage(packageName, moduleInfo);

            addTask(genPackagePage);
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }

        override protected function complete():void
        {
            super.complete();

            genPackagePage.lines.clear();
            genPackagePage = null;

            writeLines.lines.clear();
            writeLines = null;
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genPackagePage)
                writeLines.lines = (task as GeneratePackagePage).lines;
        }

    }
}
