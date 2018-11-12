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

    import pixeldroid.util.log.Log;
    import pixeldroid.util.log.LogLevel;


    public class LSDocDemoCLI extends ConsoleApplication
    {
        private static const logName:String = LSDocDemoCLI.getTypeName();
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


        private function get versionString():String
        {
            return 'lsdoc ' +LSDoc.version;
        }

        private function showUsage():void
        {
            var pNames:String = ProcessorSelector.selectionNames.join('|');

            trace('usage: lsdoc [-h|--help] [-v|--version]');
            trace('             -l|--lib <path>...');
            trace('             -o|--output-dir <path>');
            trace('             [-d|--debug]');
            trace('             [-p|--processor <name>]');
            trace('');
            trace('options:');
            trace('  -h --help           Print this screen and exit');
            trace('  -v --version        Print version and exit');
            trace('  -d --debug          Turn on debug logging');
            trace('  -l --lib <path>...  Add loomlib (multiple paths may be given)');
            trace('  -o --output-dir     Set directory for output');
            trace('  -p --processor      Select processor (' +pNames +')');

            Process.exit(EXIT_OK);
        }

        private function showVersion():void
        {
            trace(versionString);

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
            trace(versionString);

            if (!opts.getOption('o', 'output-dir').hasValue)
                exitWithErrors('no output directory specified', null);

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

            switch(processor.currentState)
            {
                case TaskState.COMPLETED:
                    exitWithSuccess('done.');
                break;

                case TaskState.FAULT:
                    exitWithErrors('errors while processing', context.errors);
                break;
            }
        }


        private function prepareProcessor(name:String):LSDocProcessor
        {
            Log.debug(logName, function():String{ return 'preparing the "' +name +'" processor'; });
            var p:LSDocProcessor = ProcessorSelector.select(name);

            p.addTaskStateCallback(TaskState.RUNNING, onProcessorStart);
            p.addTaskStateCallback(TaskState.REPORTING, onProcessorProgress);
            p.addTaskStateCallback(TaskState.COMPLETED, onProcessorComplete);
            p.addTaskStateCallback(TaskState.FAULT, onProcessorFault);

            return p;
        }

        private function onProcessorStart(task:Task):void
        {
            Log.debug(logName, function():String{ return 'onProcessorStart for ' +task; });
            trace('running..');
        }

        private function onProcessorProgress(task:Task, percent:Number):void
        {
            trace(Math.round(percent * 100) + '% complete');
        }

        private function onProcessorComplete(task:Task):void
        {
            lsdoc.modules.clear();
            lsdoc = null;
            Log.debug(logName, function():String{ return 'onProcessorComplete for ' +task; });
        }

        private function onProcessorFault(task:Task, message:String):void
        {
            Log.debug(logName, function():String{ return 'onProcessorFault for ' +task +': ' +message; });

            var context:ProcessingContext = (task as LSDocProcessor).context;
            context.appendErrors([LSDocError.processorFail(message)]);
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
