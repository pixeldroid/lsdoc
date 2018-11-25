package pixeldroid.lsdoc
{
    import system.JSON;
    import system.platform.File;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;


    /**
    Entry point for loomlib processing.

    The LSDoc class loads loomlibs, parses them,
    and makes the data available via a list of `LibModule` instances.

    @see pixeldroid.lsdoc.models.LibModule
    */
    public class LSDoc
    {
        /** LSDoc library version */
        public static const version:String = '2.0.0';

        /**
        list of extracted modules, populated via calls to `addLoomlib`
        @see #addLoomlib
        */
        public const modules:Vector.<LibModule> = [];

        private static const parser:JSON = new JSON;
        private const libPaths:Vector.<String> = [];


        /**
        retrieve a count of the total unique types defined in the currently loaded loomlibs

        @return Integer count of total types loaded
        */
        public function get numTypes():Number
        {
            var n:Number = 0;
            for each(var m:LibModule in modules)
                n += m.types.length;

            return n;
        }

        /**
        Load and parse the provided loomlib into memory.

        @param path Absolute path to a loomlib. Relative paths are not supported.

        @return List of errors encountered during parsing. An empty list indicates success.

        @see pixeldroid.lsdoc.errors.LSDocError
        */
        public function addLoomlib(path:String):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            if(File.fileExists(path))
            {
                if(!libPaths.contains(path))
                {
                    errors = errors.concat(loadAssembly(path));
                    if (0 == errors.length)
                        libPaths.push(path);
                }
            }
            else
            {
                errors.push(LSDocError.noFile("loomlib not found at path '" +path +"'."));
            }

            return errors;
        }


        private function loadAssembly(path:String):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];
            var json:String = File.loadTextFile(path);

            if (parser.loadString(json))
                LibUtils.extractTypeVector(parser.getArray('modules'), LibModule.fromJSON, modules);

            else
            {
                errors.push(LSDocError.parseFail(parser.getError()));
                errors.push(LSDocError.badLib("invalid loomlib at '" +path +"'."));
            }

            return errors;
        }

    }
}
