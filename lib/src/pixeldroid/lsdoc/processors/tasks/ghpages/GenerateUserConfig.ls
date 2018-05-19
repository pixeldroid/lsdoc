package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import system.platform.File;

    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.errors.LSDocError;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;

    import pixeldroid.task.SingleTask;

    import pixeldroid.util.log.Log;


    public class GenerateUserConfig extends SingleTask
    {
        private static const logName:String = GenerateUserConfig.getTypeName();
        private static var _yamlOptions:YamlPrinterOptions;

        private static function get yamlOptions():YamlPrinterOptions
        {
            if (!_yamlOptions)
                _yamlOptions = YamlPrinterOptions.compact;

            return _yamlOptions;
        }

        private static function getConfigYaml(userConfig:Json):Vector.<String>
        {
            var result:Vector.<String> = [];

            result.push(YamlPrinter.print(userConfig, yamlOptions));

            return result;
        }


        private var userConfigPath:String;
        private var context:ProcessingContext;

        public var lines:Vector.<String>;


        public function GenerateUserConfig(userConfigPath:String, context:ProcessingContext)
        {
            this.userConfigPath = userConfigPath;
            this.context = context;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask()'; });

            var userConfig:Json = loadConfig(userConfigPath);

            if (userConfig)
                lines = GenerateUserConfig.getConfigYaml(userConfig);

            complete();
        }

        private function loadConfig(path:String):Json
        {
            if (!File.fileExists(path))
            {
                Log.error(logName, function():String{ return 'configuration file not found'; });
                context.appendErrors([LSDocError.noFile('configuration file not found at "' +path +'"')]);
                fault('unable to load configuration file.');
                return null;
            }

            var jsonString:String = File.loadTextFile(path);
            var config:Json = Json.fromString(jsonString);

            if (!config)
            {
                Log.error(logName, function():String{ return 'unable to parse JSON at ' +path; });
                context.appendErrors([LSDocError.noFile('unable to parse JSON at "' +path +'"')]);
                fault('unable to parse JSON configuration.');
                return null;
            }

            return config;
        }

    }
}
