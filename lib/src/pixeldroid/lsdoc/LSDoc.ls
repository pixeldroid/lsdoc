package pixeldroid.lsdoc
{
    import system.JSON;
    import system.platform.File;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;


    public class LSDoc
    {
        public static const version:String = '2.0.0';
        private static const parser:JSON = new JSON;

        private const libPaths:Vector.<String> = [];
        public const modules:Vector.<LibModule> = [];


        public function get numTypes():Number
        {
            var n:Number = 0;
            for each(var m:LibModule in modules)
                n += m.types.length;

            return n;
        }

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
