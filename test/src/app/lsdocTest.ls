package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import lsdocSpec;
    import FilePathSpec;
    import StringUtilsSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                lsdocSpec,
                FilePathSpec,
                StringUtilsSpec
            ]);

            Process.exit(returnCode);
        }
    }

}
