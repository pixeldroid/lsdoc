package pixeldroid.lsdoc
{
    import system.Debug;
    import system.JSON;
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
        private var fileList:Vector.<DocFile>;


        public function LSDoc():void
        {
            initialize();
        }

        public function addDir(directory:String):void
        {
            if(!Path.dirExists(directory)) fail("directory '" +directory +'" does not exist.');

            if(!dirList.contains(directory)) dirList.push(directory);
        }

        public function filterFiles(sieve:Function):Vector.<DocFile>
        {
            return fileList.filter(sieve);
        }

        public function get dirs():Vector.<String> { return dirList.slice(); }
        public function get files():Vector.<DocFile> { return fileList.slice(); }

        public function get numDirs():Number { return dirList.length; }
        public function get numFiles():Number { return fileList.length; }


        public function scan():void
        {
            fileList = [];
            for each(var dir:String in  dirList) Path.walkFiles(dir, scanner, dir);
        }

        public function toJSON():JSON
        {
            var j:JSON = new JSON();
            var s:JSON = new JSON();

            j.initObject();
            s.initObject();

            var docfileTypes:Vector.<DocFileType> = DocFileType.getAllDocFileTypes();
            var fj:JSON = new JSON();
            var ft:Vector.<DocFile>;
            var n:Number;

            for each(var type:DocFileType in docfileTypes)
            {
                ft = filterFiles(DocFile.getTypeFilter(type));
                ft.sort(DocFile.sortByName);

                n = ft.length;
                s.setInteger(type.toString(), n);

                fj.initArray();
                for (var i:Number = 0; i < n; i++) fj.setArrayObject(i, ft[i].toJSON());
                j.setArray(type.toString(), fj);
            }

            j.setObject('summary', s);

            return j;
        }

        public function toJsonString():String
        {
            var j:JSON = toJSON();
            return j.serialize();
        }



        private function fail(message:String):void
        {
            trace('error:', message);
            Process.exit(EXIT_FAIL);
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

            fileList.push(file);
        }
    }
}
