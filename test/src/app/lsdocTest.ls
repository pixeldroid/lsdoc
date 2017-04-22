package
{
    import system.Process;
    import system.application.ConsoleApplication;
    import system.platform.File;

    import pixeldroid.bdd.SpecExecutor;
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.error.LSDocError;

    import lsdocSpec;
    import DocFileSpec;
    import DocFileTypeSpec;


    public class lsdocTest extends ConsoleApplication
    {

        override public function run():void
        {
            SpecExecutor.parseArgs();
            var returnCode:Number = SpecExecutor.exec([
                lsdocSpec,
                DocFileSpec,
                DocFileTypeSpec
            ]);

            report();

            Process.exit(returnCode);
        }


        private function report():void
        {
            trace('\ngenerating a report of all files scanned..');

            var fixtureRoot:String = 'fixtures/';
            var module:String = 'test';
            var lsdoc:LSDoc = new LSDoc();
            var err:Vector.<LSDocError> = [];

            trace('adding dirs..');
            err = err.concat(lsdoc.addDir(fixtureRoot + 'docs', module));
            err = err.concat(lsdoc.addDir(fixtureRoot + 'build', module));
            err = err.concat(lsdoc.addDir(fixtureRoot + 'src', module));
            trace(lsdoc.numDirs, err.join());

            trace('scanning..');
            err = err.concat(lsdoc.scan());
            trace(err.join());

            trace('processing..');
            err = err.concat(lsdoc.process());
            trace(err.join());

            trace('report:');
            trace(lsdoc.toJSON().getObject('summary').serialize());

            trace('rendering..');
            err = err.concat(lsdoc.render());
            trace(err.join());

            if (File.writeTextFile('docfiles.json', lsdoc.toJsonString())) trace('done.');
            else trace('write failed');
        }
    }

}
