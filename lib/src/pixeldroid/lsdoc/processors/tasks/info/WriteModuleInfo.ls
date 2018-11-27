package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.info.GenerateModuleInfo;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.file.FilePath;
    import pixeldroid.util.log.Log;


    public class WriteModuleInfo extends SequentialTask
    {
        private static const logName:String = WriteModuleInfo.getTypeName();
        private var module:LibModule;
        private var genInfo:GenerateModuleInfo;
        private var writeLines:WriteLines;


        public function WriteModuleInfo(module:LibModule, context:ProcessingContext)
        {
            this.module = module;

            genInfo = new GenerateModuleInfo(module);

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(context.outPath, module.name);

            addTask(genInfo);
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genInfo)
                writeLines.lines = (task as GenerateModuleInfo).lines;
        }

    }
}
