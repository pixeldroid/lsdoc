package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GenerateUserConfig;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.log.Log;


    /**
    Task group that handles loading, translating and writing to file the `_config.yml` for an **lsdoc** Jekyll site
    */
    public class WriteUserConfig extends SequentialTask
    {
        private static const logName:String = WriteUserConfig.getTypeName();
        private var genUserConfig:GenerateUserConfig;
        private var writeLines:WriteLines;


        public function WriteUserConfig(userConfigPath:String, targetConfigPath:String, context:ProcessingContext)
        {
            genUserConfig = new GenerateUserConfig(userConfigPath, context);
            addTask(genUserConfig);

            writeLines = new WriteLines(context);
            writeLines.outfile = targetConfigPath;
            addTask(writeLines);

            addSubTaskStateCallback(TaskState.COMPLETED, handleSubTaskCompletion);
        }

        override protected function complete():void
        {
            super.complete();

            writeLines.lines.clear();
            writeLines = null;
        }


        private function handleSubTaskCompletion(task:Task):void
        {
            if (task == genUserConfig)
                writeLines.lines = (task as GenerateUserConfig).lines;
        }

    }
}
