package
{
    import system.Process;
    import system.application.ConsoleApplication;
    import system.platform.File;

    import pixeldroid.bdd.SpecExecutor;
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;

    import lsdocSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                lsdocSpec
            ]);

            report();

            Process.exit(returnCode);
        }

        private function report():void
        {
            trace('');
            trace('reporting:');

            var lsd:LSDoc = new LSDoc();
            var err:Vector.<LSDocError> = [];
            err = err.concat(lsd.addLoomlib('fixtures/lsdoc.loomlib'));
            err = err.concat(lsd.addLoomlib('fixtures/Log.loomlib'));
            for each(var e:LSDocError in err) trace(e);
            lsd.report();
        }
    }

}
