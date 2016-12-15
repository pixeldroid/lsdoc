package pixeldroid.platform
{
    import system.platform.File;
    import system.platform.Path;


    public class File2
    {

        public static function basename(filepath:String):String
        {
            return filepath.split(Path.getFolderDelimiter()).pop();
        }

        public static function extname(filepath:String):String
        {
            var dot:Number = filepath.lastIndexOf('.');
            return (dot < 0) ? '' : filepath.substring(dot + 1, filepath.length);
        }

    }
}
