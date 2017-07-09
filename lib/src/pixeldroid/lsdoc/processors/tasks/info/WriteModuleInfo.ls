package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.info.GenerateModuleInfo;

    import pixeldroid.platform.FilePath;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.Log;


    public class WriteModuleInfo extends SequentialTask
    {
        private static const logName:String = WriteModuleInfo.getTypeName();
        private var module:ModuleInfo;
        private var genInfo:GenerateModuleInfo;
        private var writeLines:WriteLines;


        public function WriteModuleInfo(module:ModuleInfo, context:ProcessingContext)
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
