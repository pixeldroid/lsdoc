package
{
    import system.platform.Path;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.platform.FilePath;


    public static class FilePathSpec
    {
        private static var it:Thing;
        private static const path:String = ['a', 'b', 'c', 'file.ext'].join(Path.getFolderDelimiter());

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('FilePath');

            it.should('find the containing folder of a filepath', find_dirname);
            it.should('find the basename of a file within a filepath', find_basename);
            it.should('find the basename from a filepath minus extension', find_basename_sans_ext);
            it.should('find the extension suffix of a file within a filepath', find_extname);
            it.should('test that a path represents a directory', test_dir);
            it.should('test that a path represents a file', test_file);
            it.should('join path components into a filepath string', join_components);
            it.should('strip components of leading or trailing delimiters when joining, except an initial leading delimiter', strip_join);
        }


        private static function find_dirname():void
        {
            var d:String = Path.getFolderDelimiter();
            var dir:String = ['a', 'b', 'c'].join(d);
            it.expects(FilePath.dirname(path)).toEqual(dir);
            it.expects(FilePath.dirname(d +path)).toEqual(d +dir);
            it.expects(FilePath.dirname(dir +d)).toEqual(dir);
        }

        private static function find_basename():void
        {
            it.expects(FilePath.basename(path)).toEqual('file.ext');
        }

        private static function find_basename_sans_ext():void
        {
            it.expects(FilePath.basename(path, '.*')).toEqual('file');
            it.expects(FilePath.basename(path, '.ext')).toEqual('file');
            it.expects(FilePath.basename(path, 'ext')).toEqual('file.ext');
            it.expects(FilePath.basename(path, '.xyz')).toEqual('file.ext');
        }

        private static function find_extname():void
        {
            it.expects(FilePath.extname(path)).toEqual('ext');
        }

        private static function test_dir():void
        {
            var dirpath:String = 'fixtures';
            it.expects(FilePath.isDir(dirpath)).toBeTruthy();
            it.expects(FilePath.isDir('no-such-dir')).toBeFalsey();

            var d:String = Path.getFolderDelimiter();
            var filepath:String = ['fixtures', 'file'].join(d);
            it.expects(FilePath.isDir(filepath)).toBeFalsey();
        }

        private static function test_file():void
        {
            var d:String = Path.getFolderDelimiter();
            var filepath:String = ['fixtures', 'file'].join(d);
            it.expects(FilePath.isFile(filepath)).toBeTruthy();
            it.expects(FilePath.isFile('no-such-file')).toBeFalsey();

            var dirpath:String = 'fixtures';
            it.expects(FilePath.isFile(dirpath)).toBeFalsey();
        }

        private static function join_components():void {
            var b:PathObject = new PathObject('b');
            var c:PathObject = new PathObject('c');
            it.expects(FilePath.join('a', 'b', 'c', 'file.ext')).toEqual(path);
            it.expects(FilePath.join('a', ['b', 'c'], 'file.ext')).toEqual(path);
            it.expects(FilePath.join('a', b, c, 'file.ext')).toEqual(path);
            it.expects(FilePath.join('a', [b, c], 'file.ext')).toEqual(path);
        }

        private static function strip_join():void {
            var d:String = Path.getFolderDelimiter();
            it.expects(FilePath.join(d +'a', 'b', 'c', 'file.ext')).toEqual(d +path);
            it.expects(FilePath.join('a'+d, d+'b', d+'c'+d, 'file.ext')).toEqual(path);
            it.expects(FilePath.join('a'+d+d+'b', 'c'+d+d+'file.ext')).not.toEqual(path);
        }

    }

    private class PathObject
    {
        private var _path:String;

        public function PathObject(path:String) { _path = path; }
        public function toString():String { return _path; }
    }
}
