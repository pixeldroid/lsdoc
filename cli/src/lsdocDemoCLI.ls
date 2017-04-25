package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.cli.OptionParser;
    import pixeldroid.cli.OptionParser;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;


    public class lsdocDemoCLI extends ConsoleApplication
    {
        private static const EXIT_OK:Number = 0;
        private static const EXIT_ERR:Number = 1;

        override public function run():void
        {
            var opts:OptionParser = new OptionParser();
            opts.parse();

            if (opts.getOption('h', 'help').isSet) usage();
            if (opts.getOption('v', 'version').isSet) version();
            if (opts.getOption('l', 'lib').hasValue) runApp(opts);
            usage();
        }


        private function usage():void
        {
            trace('usage: [-v|--version] [-h|--help]');
            trace('       -l|--lib <lib1[,lib2,..]>');

            Process.exit(EXIT_OK);
        }

        private function version():void
        {
            trace('lsdoc ' +LSDoc.version);

            Process.exit(EXIT_OK);
        }

        private function runApp(opts:OptionParser):void
        {
            var paths:Vector.<String> = opts.getOption('l', 'lib').value;
            addLoomlibs(paths);

            Process.exit(EXIT_OK);
        }

        private function addLoomlibs(paths:Vector.<String>):void
        {
            var lsd:LSDoc = new LSDoc();
            var err:Vector.<LSDocError> = [];

            for each(var libPath:String in paths)
            {
                err = err.concat(lsd.addLoomlib(libPath));
            }
            for each(var e:LSDocError in err) trace(e);

            lsd.report();
        }

    }
}
