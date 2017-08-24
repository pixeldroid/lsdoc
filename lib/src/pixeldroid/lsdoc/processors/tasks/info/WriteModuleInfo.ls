package pixeldroid.lsdoc.processors.tasks.info
{
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.info.GenerateLibModule;

    import pixeldroid.platform.FilePath;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.Log;


    public class WriteLibModule extends SequentialTask
    {
        private static const logName:String = WriteLibModule.getTypeName();
        private var module:LibModule;
        private var genInfo:GenerateLibModule;
        private var writeLines:WriteLines;


        public function WriteLibModule(module:LibModule, context:ProcessingContext)
        {
            this.module = module;

            genInfo = new GenerateLibModule(module);

            writeLines = new WriteLines(context);
            writeLines.outfile = FilePath.join(context.outPath, module.name);

            addTask(genInfo);
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genInfo)
                writeLines.lines = (task as GenerateLibModule).lines;
        }

    }
}
