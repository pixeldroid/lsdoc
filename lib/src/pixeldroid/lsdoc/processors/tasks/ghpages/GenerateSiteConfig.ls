package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import system.platform.File;

    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.lsdoc.errors.LSDocError;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;

    import pixeldroid.task.SingleTask;

    import pixeldroid.util.Log;


    public class GenerateSiteConfig extends SingleTask
    {
        private static const logName:String = GenerateSiteConfig.getTypeName();
        private static var _yamlOptions:YamlPrinterOptions;

        private static function get yamlOptions():YamlPrinterOptions
        {
            if (!_yamlOptions)
                _yamlOptions = YamlPrinterOptions.compact;

            return _yamlOptions;
        }

        private static function getMergedConfigYaml(templateConfig:Json, userConfig:Json):Vector.<String>
        {
            var result:Vector.<String> = [];

            Json.merge(templateConfig, userConfig);
            result.push(YamlPrinter.print(templateConfig, yamlOptions));

            return result;
        }


        private var templateConfigPath:String;
        private var userConfigPath:String;
        private var context:ProcessingContext;

        public var lines:Vector.<String>;


        public function GenerateSiteConfig(templateConfigPath:String, userConfigPath:String, context:ProcessingContext)
        {
            this.templateConfigPath = templateConfigPath;
            this.userConfigPath = userConfigPath;
            this.context = context;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask()'; });

            var templateConfig:Json = loadConfig(templateConfigPath);
            var userConfig:Json = loadConfig(userConfigPath);

            if (templateConfig && userConfig)
                lines = GenerateSiteConfig.getMergedConfigYaml(templateConfig, userConfig);

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
