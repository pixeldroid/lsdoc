package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import DependenciesSpec;
    import FilePathSpec;
    import LibModuleSpec;
    import LSDocSpec;
    import StringUtilsSpec;


    public class LSDocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                DependenciesSpec,
                DocTagSpec,
                FilePathSpec,
                LibModuleSpec,
                LSDocSpec,
                StringUtilsSpec
            ]);

            Process.exit(returnCode);
        }
    }

}
