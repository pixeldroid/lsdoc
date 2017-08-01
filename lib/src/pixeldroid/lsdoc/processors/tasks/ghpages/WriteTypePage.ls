package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GenerateTypePage;

    import pixeldroid.platform.FilePath;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.Log;


    /**
    Task group that handles generating and writing to file the page content for a type page
    */
    public class WriteTypePage extends SequentialTask
    {
        private static const logName:String = WriteTypePage.getTypeName();
        private var genTypePage:GenerateTypePage;
        private var writeLines:WriteLines;
        private var writeDescription:WriteLines;


        public function WriteTypePage(apiPath:String, typeInfo:TypeInfo, moduleInfo:ModuleInfo, context:ProcessingContext)
        {
            var packageComponents:Vector.<String> = typeInfo.packageString.split('.');
            var fileName:String = typeInfo.name +'.html';
            var descriptionName:String = '_' +typeInfo.name +'-description.md';

            genTypePage = new GenerateTypePage(typeInfo, moduleInfo);
            addTask(genTypePage);

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(apiPath, packageComponents, fileName);
            addTask(writeLines);

            writeDescription = new WriteLines(context);
            writeDescription.lines = [typeInfo.docString];
            writeDescription.outfile = FilePath.join(apiPath, packageComponents, descriptionName);
            addTask(writeDescription);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }

        override protected function complete():void
        {
            super.complete();

            genTypePage.lines.clear();
            genTypePage = null;

            writeLines.lines.clear();
            writeLines = null;

            writeDescription.lines.clear();
            writeDescription = null;
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genTypePage)
                writeLines.lines = (task as GenerateTypePage).lines;
        }

    }
}
