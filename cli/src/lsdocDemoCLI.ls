package
{
    import system.Process;
    import system.application.ConsoleApplication;

    import pixeldroid.cli.OptionParser;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.processors.LSDocProcessor;
    import pixeldroid.lsdoc.processors.ProcessorSelector;
    import pixeldroid.lsdoc.processors.ProcessingContext;

    import pixeldroid.task.Task;
    import pixeldroid.task.TaskState;

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
            if (opts.getOption('l', 'lib').hasValue) runProcessor(opts);
            showUsage();
        }


        private function showUsage():void
        {
            var pNames:String = ProcessorSelector.selectionNames.join('|');

            trace('usage: lsdoc [-h|--help] [-v|--version]');
            trace('             -l|--lib <path>...');
            trace('             -o|--output-dir <path>');
            trace('             [-d|--debug]');
            trace('             [-e|--examples-src <path>]');
            trace('             [-g|--guides-src <path>]');
            trace('             [-i|--index-src <path>]');
            trace('             [-p|--processor <name>]');
            trace('             [-t|--templates-src <path>]');
            trace('');
            trace('options:');
            trace('  -h --help           Print this screen and exit');
            trace('  -v --version        Print version and exit');
            trace('  ');
            trace('  -d --debug          Turn on debug logging');
            trace('  -e --examples-src   Set examples source directory');
            trace('  -g --guides-src     Set guides source directory');
            trace('  -i --index-src      Set home page source file');
            trace('  -l --lib <path>...  Add loomlib (multiple paths may be given)');
            trace('  -o --output-dir     Set directory for output');
            trace('  -p --processor      Select processor (' +pNames +')');
            trace('  -t --templates-src  Set doc templates directory');

            Process.exit(EXIT_OK);
        }

        private function showVersion():void
        {
            trace('lsdoc ' +LSDoc.version);

            Process.exit(EXIT_OK);
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

        private function runProcessor(opts:OptionParser):void
        {
            if (!opts.getOption('o', 'output-dir').hasValue)
                exitWithErrors('no output directory specified', []);

            lsdoc = new LSDoc();

            var context:ProcessingContext = new ProcessingContext();
            context.lsdoc = lsdoc;
            context.opts = opts.toDictionary();
            context.outPath = opts.getOption('o', 'output-dir').firstValue;

            var paths:Vector.<String> = opts.getOption('l', 'lib').value;
            context.appendErrors(addLoomlibs(lsdoc, paths));

            if (context.hasErrors)
                exitWithErrors('errors while adding loomlibs', context.errors);

            var name:String = opts.getOption('p', 'processor', [ProcessorSelector.defaultName]).firstValue;
            var processor:LSDocProcessor = prepareProcessor(name);

            processor.initialize(context);

            Log.debug(logName, function():String{ return 'context:\n' +context.toString(); });
            if (context.hasErrors)
                exitWithErrors('errors while initializing processor', context.errors);

            processor.start();
        }


        private function prepareProcessor(name:String):LSDocProcessor
        {
            Log.debug(logName, function():String{ return 'preparing the "' +name +'" processor'; });
            var p:LSDocProcessor = ProcessorSelector.select(name);

            p.addTaskStateCallback(TaskState.RUNNING, onStart);
            p.addTaskStateCallback(TaskState.REPORTING, onProgress);
            p.addTaskStateCallback(TaskState.COMPLETED, onComplete);
            p.addTaskStateCallback(TaskState.FAULT, onFault);

            return p;
        }

        private function onStart(task:Task):void
        {
            Log.debug(logName, function():String{ return 'onStart for ' +task; });
            trace('running..');
        }

        private function onProgress(task:Task, percent:Number):void
        {
            trace(Math.round(percent * 100) + '% complete');
        }

        private function onComplete(task:Task):void
        {
            Log.debug(logName, function():String{ return 'onComplete for ' +task; });
            exitWithSuccess('done.');
        }

        private function onFault(task:Task, message:String):void
        {
            Log.debug(logName, function():String{ return 'onFault for ' +task; });
            var context:ProcessingContext = (task as LSDocProcessor).context;
            exitWithErrors(message, context.errors);
        }


        private function exitWithSuccess(message:String):void
        {
            trace(message);

            Process.exit(EXIT_OK);
        }

        private function exitWithErrors(message:String, err:Vector.<LSDocError>):void
        {
            trace(message);
            for each(var e:LSDocError in err) trace(e);

            Process.exit(EXIT_ERR);
        }

    }
}
