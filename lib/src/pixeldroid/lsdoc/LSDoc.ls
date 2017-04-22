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

        private var modules:Dictionary.<String,Vector.<String>>;
        private var fileList:Vector.<DocFile>;


        public function LSDoc():void
        {
            initialize();
        }

        /**
            Submit a directory to be scanned for docfiles.

            @param directory Folder to scan recursively for docfiles
            @param module Name of module to associate files with

            @return List of `LSDocError`; empty on success
        */
        public function addDir(directory:String, module:String):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            if(Path.dirExists(directory))
            {
                var dirList:Vector.<String> = modules[module];
                if (dirList)
                {
                    if(!dirList.contains(directory)) dirList.push(directory);
                }
                else
                {
                    dirList = [directory];
                    modules[module] = dirList;
                }
            }
            else
            {
                errors.push(noDirectoryError("directory '" +directory +'" does not exist.'));
            }

            return errors;
        }

        /**
            Filter the list of docfiles using the provided sieve.

            Sieve must match the signature expected by `Vector.filter`:
               ⇥`function(item:Object, index:Number, vector:Vector):Boolean`

            @param sieve A filter function to select desired entries from `fileList`

            @see pixeldroid.lsdoc.model.DocFile#getDirFilter
            @see pixeldroid.lsdoc.model.DocFile#getTypeFilter
        */
        public function filterFiles(sieve:Function):Vector.<DocFile>
        {
            return fileList.filter(sieve);
        }

        public function get dirs():Vector.<String> {
            var allDirs:Vector.<String> = [];

            for each(var dirList:Vector.<String> in modules)
            {
                allDirs = dirList.concat(allDirs);
            }

            return allDirs;
        }

        public function get files():Vector.<DocFile> { return fileList.slice(); }

        public function get numDirs():Number { return dirs.length; }

        public function get numFiles():Number { return fileList.length; }


        /**
            Collect the list of files to process
        */
        public function scan():Vector.<LSDocError>
        {
            fileList = [];
            if (modules.length == 0) return [noFileError('no directories added. nothing to scan.')];

            var errors:Vector.<LSDocError> = [];
            var searchList:Vector.<String> = []; // track the module names for the error message below
            var dirList:Vector.<String>;
            var payload:Dictionary.<String,String>;

            for (var m:String in modules)
            {
                searchList.push(m);
                dirList = modules[m];

                for each(var d:String in dirList)
                {
                    payload = {
                        'module': m,
                        'root': d
                    };
                    Path.walkFiles(d, scanner, payload);
                }
            }

            if (fileList.length == 0)
            {
                errors.push(noFileError('no doc files found in ["' + searchList.join('", "') +'"].'));
            }

            return errors;
        }

        /**
            Process the doc files to generate derived data / links. etc.
        */
        public function process():Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            var docfileTypes:Vector.<DocFileType> = DocFileType.getAllDocFileTypes();
            var docfiles:Vector.<DocFile>;

            for each(var type:DocFileType in docfileTypes)
            {
                docfiles = filterFiles(DocFile.getTypeFilter(type));
                // TODO: process doc files with type-specific processor
            }

            return errors;
        }

        /**
            Render the processed doc comments to an output format.
        */
        public function render(/*renderer:LSDocRenderer*/):Vector.<LSDocError>
        {
            var errors:Vector.<LSDocError> = [];

            // TODO: render

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



        private function extractFromAssembly(module:String, filepath:String, root:String):void
        {
            // TODO: extract from assembly
        }

        private function extractFromFile(module:String, filepath:String, root:String):void
        {
            // TODO: extract rest of info needed by process()
            //  see: http://localhost:4567/projects/lsdoc/loomlib-json#overview
            var file:DocFile = new DocFile(module, filepath, root);
            fileList.push(file);
        }

        private function initialize():void
        {
            modules = {};
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

            var args:Dictionary.<String,String> = payload as Dictionary.<String,String>;
            var module:String = args['module'];
            var root:String = args['root'];

            if (DocFileType.isAssembly(filepath)) extractFromAssembly(module, filepath, root);
            else extractFromFile(module, filepath, root);
        }
    }
}
