package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.processors.tasks.WriteLines;
    import pixeldroid.lsdoc.processors.tasks.ghpages.GenerateSiteConfig;

    import pixeldroid.task.SequentialTask;
    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

    import pixeldroid.util.log.Log;


    /**
    Task group that handles loading, merging and writing to file the `_config.yml` for an **lsdoc** Jekyll site
    */
    public class WriteSiteConfig extends SequentialTask
    {
        private static const logName:String = WriteSiteConfig.getTypeName();
        private var genSiteConfig:GenerateSiteConfig;
        private var writeLines:WriteLines;


        public function WriteSiteConfig(templateConfigPath:String, userConfigPath:String, targetConfigPath:String, context:ProcessingContext)
        {
            genSiteConfig = new GenerateSiteConfig(templateConfigPath, userConfigPath, context);
            addTask(genSiteConfig);

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
            if (task == genSiteConfig)
                writeLines.lines = (task as GenerateSiteConfig).lines;
        }

    }
}
