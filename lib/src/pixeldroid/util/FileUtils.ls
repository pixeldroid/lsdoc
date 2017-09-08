package pixeldroid.util
{
    import system.platform.File;
    import system.platform.Path;

    import pixeldroid.util.FilePath;


    /**
        A utlity class for manipulating files.
    */
    public final class FileUtils
    {
        /**
            Recursively copy files and subdirectories from source dir to destination dir.

            The containing directory is not copied, only its contents.
        */
        public static function copyContents(source:String, destination:String):Boolean
        {
            if (!Path.dirExists(source))
                return false;

            // collect list of files to copy
            var files = new Vector.<String>;
            Path.walkFiles(source, fileCollector, files);

            var dst:String;
            var dstDir:String;
            var rootLength:Number = source.length;
            for each (var file:String in files)
            {
                dst = FilePath.join(destination, file.substring(rootLength, file.length));
                dstDir = FilePath.dirname(dst);

                if (!Path.dirExists(dstDir))
                    if (!Path.makeDir(dstDir))
                        return false;

                if (!File.copy(file, dst))
                    return false;
            }

            return true;
        }

        /**
            Recursively remove files and subdirectories from given dir.

            NOTE: empty directories are unable to be removed, only directories with files inside

            The containing directory is also removed.
        */
        public static function remove(dir:String):Boolean
        {
            if (!Path.dirExists(dir))
                return false;

            var files = new Vector.<String>;
            var dirs = new Vector.<String>;

            // collect list of files for removal
            // FIXME: empty directories are not found by Path.walkFiles  :(
            Path.walkFiles(dir, fileCollector, files);
            dirs.pushSingle(dir);

            // remove files and save containing dirnames
            var dirname:String;
            for each (var filename in files)
            {
                dirname = FilePath.dirname(filename);

                if (!dirs.contains(dirname))
                    dirs.pushSingle(dirname);

                if (!File.removeFile(filename))
                    return false;
            }

            // remove dirs in reverse order
            var n:Number = dirs.length - 1;

            for (var i:Number in dirs)
                if (!Path.removeDir(dirs[n - i]))
                    return false;

            return true;
        }


        private static function fileCollector(filename:String, files:Vector.<String>)
        {
            files.pushSingle(filename);
        }
    }
}
