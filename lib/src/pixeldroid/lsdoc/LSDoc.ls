package pixeldroid.lsdoc
{
    import system.Debug;
    import system.Process;
    import system.platform.Path;

    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;


    public class LSDoc
    {
        public static const version:String = '1.0.0';

        private static const EXIT_FAIL:Number = 1;
        private const logName:String = getFullTypeName().split('.').pop();
        private var dirList:Vector.<String>;
        private var _files:Vector.<DocFile>;


        private function fail(message:String):void
        {
            trace('error:', message);
            Process.exit(EXIT_FAIL);
        }


        public function LSDoc():void
        {
            initialize();
        }

        public function addDir(directory:String):void
        {
            if(!Path.dirExists(directory)) fail("directory '" +directory +'" does not exist.');

            if(!dirList.contains(directory)) dirList.push(directory);
        }

        public function get files():Vector.<DocFile> { return _files.slice(); }

        public function get numDirs():Number { return dirList.length; }
        public function get numFiles():Number { return _files.length; }


        public function scan():void
        {
            _files = [];
            for each(var dir:String in  dirList) Path.walkFiles(dir, scanner, dir);
        }


        private function initialize():void
        {
            dirList = [];
        }

        private function scanner(filepath:String, payload:Object):void
        {
            if (!DocFileType.isDocFile(filepath)) return;

            var root:String = payload as String;
            var file:DocFile = new DocFile(filepath, root);

            _files.push(file);
        }
    }
}
