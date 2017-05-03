package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.cli.OptionParser;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.ProcessorSelector;

    import pixeldroid.util.Log;
    import pixeldroid.util.log.LogLevel;


    public class lsdocDemoCLI extends ConsoleApplication
    {
        private static const logName:String = lsdocDemoCLI.getTypeName();
        private static const EXIT_OK:Number = 0;
        private static const EXIT_ERR:Number = 1;

        private var lsdoc:LSDoc;


        override public function run():void
        {
            var opts:OptionParser = new OptionParser();
            opts.parse();

            Log.level = (opts.getOption('d', 'debug').isSet) ? LogLevel.DEBUG : LogLevel.NONE;
            Log.info(logName, function():String{ return 'debug logging activated'; });
            Log.debug(logName, function():String{ return 'running with options:\n' +opts; });

            if (opts.getOption('h', 'help').isSet) showUsage();
            if (opts.getOption('v', 'version').isSet) showVersion();
            if (opts.getOption('l', 'lib').hasValue) runApp(opts);
            showUsage();
        }


        private function showUsage():void
        {
            var pNames:String = ProcessorSelector.selectionNames.join('|');

            trace('usage: lsdoc [-v|--version] [-h|--help]');
            trace('             -l|--lib <path>...');
            trace('             [-p|--processor <name>]');
            trace('             [-o|--output-dir <path>]');
            trace('             [-d|--debug]');
            trace('');
            trace('options:');
            trace('  -h --help        Print this screen and exit');
            trace('  -v --version     Print version and exit');
            trace('  -l --lib <path>  Add loomlib (multiple paths may be given)');
            trace('  -p --processor   Select processor (' +pNames +')');
            trace('  -o --output-dir  Set directory for output (default: ./docs)');
            trace('  -d --debug       Turn on debug logging');

            Process.exit(EXIT_OK);
        }

        private function showVersion():void
        {
            trace('lsdoc ' +LSDoc.version);

            Process.exit(EXIT_OK);
        }

        private function runApp(opts:OptionParser):void
        {
            lsdoc = new LSDoc();
            var err:Vector.<LSDocError> = [];

            var paths:Vector.<String> = opts.getOption('l', 'lib').value;
            err = err.concat(addLoomlibs(lsdoc, paths));

            var name:String = opts.getOption('p', 'processor', [ProcessorSelector.defaultName]).firstValue;
            var processor:LSDocProcessor = ProcessorSelector.select(name);

            var outDir:String = opts.getOption('o', 'output-dir', ['docs']).firstValue;
            err = err.concat(processor.execute(lsdoc, { 'output-dir': outDir }));

            for each(var e:LSDocError in err) trace(e);
            Process.exit(err.length == 0 ? EXIT_OK : EXIT_ERR);
        }

        private function addLoomlibs(lsdoc:LSDoc, paths:Vector.<String>):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];

            for each(var libPath:String in paths)
            {
                err = err.concat(lsdoc.addLoomlib(libPath));
            }

            return err;
        }

    }
}
