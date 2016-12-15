package pixeldroid.lsdoc.model
{
    import system.platform.Path;

    import pixeldroid.lsdoc.model.DocFileType;


    public class DocFile
    {

        private var _name:String;
        private var _packagName:String;
        private var _path:String;
        private var _root:String;
        private var _type:DocFileType;


        public function DocFile(filepath:String, root:String = ''):void
        {
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
            _packagName = components.join('.');
            _type = DocFileType.getDocFileType(_name);
        }

        public function get name():String { return _name; }
        public function get packageName():String { return _packagName; }
        public function get path():String { return _path; }
        public function get root():String { return _root; }
        public function get type():String { return _type.toString(); }

        public function toString():String { return _path; }

    }
}
