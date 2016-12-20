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

            // var fixtureRoot:String = '/Users/ellemenno/Projects/ellemenno/lsdoc/test/fixtures/';
            var fixtureRoot:String = '/Users/ellemenno/Projects/ellemenno/LoomSDK/sdk/';
            var lsdoc:LSDoc = new LSDoc();

            // lsdoc.addDir(fixtureRoot + 'docs');
            lsdoc.addDir(fixtureRoot + 'src');
            lsdoc.scan();

            var j:JSON = lsdoc.toJSON();
            var s:JSON = j.getObject('summary');

            trace(s.serialize());

            if (File.writeTextFile('docfiles.json', lsdoc.toJsonString())) trace('done.');
            else trace('write failed');
        }
    }

}
