package pixeldroid.lsdoc
{
    import system.Debug;
    import system.JSON;
    import system.Process;
    import system.platform.Path;

    import pixeldroid.lsdoc.error.LSDocError;
    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;


    public class LSDoc
    {
        public static const version:String = '1.0.0';

        private var dirList:Vector.<String>;
        private var fileList:Vector.<DocFile>;


        public function LSDoc():void
        {
            initialize();
        }

        public function addDir(directory:String):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            if(Path.dirExists(directory))
            {
                if(!dirList.contains(directory)) dirList.push(directory);
            }
            else
            {
                errors.push(noDirectoryError("directory '" +directory +'" does not exist.'));
            }

            return errors;
        }

        public function filterFiles(sieve:Function):Vector.<DocFile>
        {
            return fileList.filter(sieve);
        }

        public function get dirs():Vector.<String> { return dirList.slice(); }
        public function get files():Vector.<DocFile> { return fileList.slice(); }

        public function get numDirs():Number { return dirList.length; }
        public function get numFiles():Number { return fileList.length; }


        /**
            Collect the list of files to process
        */
        public function scan():Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            if (dirList.length == 0)
            {
                errors.push(noFileError('no directories added. nothing to scan.'));
                return errors;
            }

            fileList = [];
            for each(var dir:String in dirList) Path.walkFiles(dir, scanner, dir);

            if (fileList.length == 0)
            {
                errors.push(noFileError('no doc files found in ["' + dirList.join('", "') +'"].'));
            }

            return errors;
        }

        /**
            Process the scanned files to extract doc comment data.
        */
        public function process():Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            return errors;
        }

        /**
            Render the processed doc comments to an output format.
        */
        public function render(/*renderer:LSDocRenderer*/):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            return errors;
        }

        /**
            Export a summary of the scanned files as a JSON object.
        */
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

        /**
            Serialize the JSON summary to string.
        */
        public function toJsonString():String
        {
            var j:JSON = toJSON();
            return j.serialize();
        }



        private function initialize():void
        {
            dirList = [];
        }

        private function noDirectoryError(msg:String):LSDocError
        {
            return new LSDocError(msg, LSDocError.DIR_NOT_FOUND);
        }

        private function noFileError(msg:String):LSDocError
        {
            return new LSDocError(msg, LSDocError.FILE_NOT_FOUND);
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
