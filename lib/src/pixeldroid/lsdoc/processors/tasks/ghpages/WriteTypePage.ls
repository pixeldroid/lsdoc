package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GenerateTypePage;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.FilePath;
    import pixeldroid.util.Log;


    /**
    Task group that handles generating and writing to file the page content for a type page
    */
    public class WriteTypePage extends SequentialTask
    {
        private static const logName:String = WriteTypePage.getTypeName();
        private var genTypePage:GenerateTypePage;
        private var writeLines:WriteLines;


        public function WriteTypePage(apiPath:String, typeInfo:LibType, moduleInfo:LibModule, context:ProcessingContext)
        {
            var packageComponents:Vector.<String> = typeInfo.packageString.split('.');
            var fileName:String = typeInfo.name +'.html';

            genTypePage = new GenerateTypePage(typeInfo, moduleInfo);
            addTask(genTypePage);

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(apiPath, packageComponents, fileName);
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }

        override protected function complete():void
        {
            super.complete();

            genTypePage.lines.clear();
            genTypePage = null;

            writeLines.lines.clear();
            writeLines = null;
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genTypePage)
                writeLines.lines = (task as GenerateTypePage).lines;
        }

    }
}
