package
{
    import system.Process;
    import system.application.ConsoleApplication;
    import system.platform.File;

    import pixeldroid.bdd.SpecExecutor;
    import pixeldroid.lsdoc.LSDoc;

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

            report();

            Process.exit(returnCode);
        }


        private function report():void
        {
            trace('\ngenerating a report of all files scanned..');

            var fixtureRoot:String = 'fixtures/';
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'docs');
            lsdoc.addDir(fixtureRoot + 'src');
            lsdoc.scan();

            trace(lsdoc.toJSON().getObject('summary').serialize());

            if (File.writeTextFile('docfiles.json', lsdoc.toJsonString())) trace('done.');
            else trace('write failed');
        }
    }

}
