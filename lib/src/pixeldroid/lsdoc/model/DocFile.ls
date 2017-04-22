package pixeldroid.lsdoc.model
{
    import system.JSON;
    import system.platform.Path;

    import pixeldroid.lsdoc.model.DocFileType;


    public class DocFile
    {

        private var _module:String;
        private var _name:String;
        private var _path:String;
        private var _root:String;
        private var _type:DocFileType;


        // public static function getModuleFilter(module:String):Function

        public static function getDirFilter(directory:String):Function
        {
            return function(item:Object, index:Number, vector:Vector):Boolean
            {
                var docfile:DocFile = item as DocFile;
                return (docfile.root == directory);
            };
        }

        public static function getTypeFilter(type:DocFileType):Function
        {
            return function(item:Object, index:Number, vector:Vector):Boolean
            {
                var docfile:DocFile = item as DocFile;
                return (docfile.type == type.toString());
            };
        }

        public static function sortByName(x:Object, y:Object):Number
        {
            // 0 for equality, 1 for x after y and -1 for x before y

            var nx:String = (x as DocFile).name;
            var ny:String = (y as DocFile).name;

            if (nx == ny)
            {
                nx = (x as DocFile).path;
                ny = (y as DocFile).path;
            }

            if (nx == ny) return 0;

            /* BUG: this causes outer sort to abort! ?!
            var names:Vector.<String> = [nx, ny];
            names.sort(); // <-- culprit
            if (names[0] == nx) return -1;
            */

            var i:Number = 0;
            var j:Number = Math.min(nx.length, ny.length);
            while ((i < j) && (nx.charAt(i) == ny.charAt(i))) i++;

            return (nx.charCodeAt(i) < ny.charCodeAt(i)) ? -1 : 1;
        }


        public function DocFile(module:String, filepath:String, root:String = ''):void
        {
            _module = module;
            setPath(filepath, root);
        }

        public function setPath(filepath:String, root:String = ''):void
        {
            var rootLength:Number = root.length;
            var lastSlash:Number = filepath.lastIndexOf(Path.getFolderDelimiter(), rootLength) + 1;
            var n:Number = Math.max(rootLength, lastSlash);

            _root = root;
            _path = filepath.substring(n, filepath.length);

            var components:Vector.<String> = _path.split(Path.getFolderDelimiter());

            _name = components.pop();
            _type = DocFileType.getDocFileType(_name);
        }

        public function get name():String { return _name; }
        public function get module():String { return _module; }
        public function get path():String { return _path; }
        public function get root():String { return _root; }
        public function get type():String { return _type.toString(); }

        public function toString():String { return _path +' (' +type +')'; }

        public function toJSON():JSON
        {
            var j:JSON = new JSON();
            j.initObject();

            j.setString('module', _module);
            j.setString('name', _name);
            j.setString('path', _path);
            j.setString('root', _root);
            j.setString('type', _type.toString());

            return j;
        }

    }
}
