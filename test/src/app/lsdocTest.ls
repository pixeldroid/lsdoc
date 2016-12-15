package
{
    import system.application.ConsoleApplication;

    import pixeldroid.bdd.SpecExecutor;

    import lsdocSpec;


    public class lsdocTest extends ConsoleApplication
    {
        override public function run():void
        {
            SpecExecutor.parseArgs();

            SpecExecutor.exec([
                lsdocSpec
            ]);
        }
    }

}
