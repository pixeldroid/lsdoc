package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import lsdocSpec;
    import DocFileTypeSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                lsdocSpec,
                DocFileTypeSpec
            ]);

            Process.exit(returnCode);
        }
    }

}
