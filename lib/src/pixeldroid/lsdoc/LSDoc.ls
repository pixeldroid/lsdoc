package pixeldroid.lsdoc
{
    import system.JSON;
    import system.platform.File;

    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;


    public class LSDoc
    {
        public static const version:String = '1.0.0';
        private static const parser:JSON = new JSON;

        private const libPaths:Vector.<String> = [];
        public const modules:Vector.<ModuleInfo> = [];


        public function LSDoc():void
        {
        }

        public function addLoomlib(path:String):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            if(File.fileExists(path))
            {
                if(!libPaths.contains(path))
                {
                    errors = errors.concat(loadAssembly(path));
                    if (0 == errors.length) libPaths.push(path);
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
            {
                var m:JSON = parser.getArray('modules');
                var n:Number = m.getArrayCount();
                for (var i:Number = 0; i < n; i++) modules.push(ModuleInfo.fromJSON(m.getArrayObject(i)));
            }
            else
            {
                errors.push(LSDocError.parseFail(parser.getError()));
                errors.push(LSDocError.badLib("invalid loomlib at '" +path +"'."));
            }

            return errors;
        }

    }
}
