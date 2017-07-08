package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import lsdocSpec;
    import FilePathSpec;
    import ModuleInfoSpec;
    import StringUtilsSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                lsdocSpec,
                FilePathSpec,
                ModuleInfoSpec,
                StringUtilsSpec
            ]);

            Process.exit(returnCode);
        }
    }

}
