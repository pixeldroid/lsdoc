package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import FilePathSpec;
    import LibModuleSpec;
    import LSDocSpec;
    import StringUtilsSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
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
