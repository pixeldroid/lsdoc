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


    public class WriteTypePage extends SequentialTask
    {
        private static const logName:String = WriteTypePage.getTypeName();
        private var genTypePage:GenerateTypePage;
        private var writeLines:WriteLines;


        public function WriteTypePage(apiPath:String, typeInfo:TypeInfo, moduleInfo:ModuleInfo, context:ProcessingContext)
        {
            var writeDescription:WriteLines;
            var packageComponents:Vector.<String> = typeInfo.packageString.split('.');
            var fileName:String = typeInfo.name +'.html';
            var descriptionName:String = '_' +typeInfo.name +'-description.md';

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(apiPath, packageComponents, fileName);

            writeDescription = new WriteLines(context);
            writeDescription.lines = [typeInfo.docString];
            writeDescription.outfile = FilePath.join(apiPath, packageComponents, descriptionName);

            genTypePage = new GenerateTypePage(typeInfo, moduleInfo);

            addTask(genTypePage);
            addTask(writeLines);
            addTask(writeDescription);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genTypePage)
                writeLines.lines = (task as GenerateTypePage).lines;
        }

    }
}
