package pixeldroid.lsdoc.errors
{
    import system.errors.Error;


    /**
    Provides error codes and messages for problems that might be encountered during docs generation.
    */
    public class LSDocError extends Error
    {

        /** indicates a file was unable to be removed */
        public static const DELETE_FAIL:String = 'unable to delete file';

        /** indicates a directory was unable to be created */
        public static const DIR_FAIL:String = 'unable to create directory';

        /** indicates a directory was unable to be found on the file system */
        public static const DIR_NOT_FOUND:String = 'directory not found';

        /** indicates a file was unable to be found on the file system */
        public static const FILE_NOT_FOUND:String = 'file not found';

        /** indicates the provided file does not appear to be a valid loomlib */
        public static const INVALID_LOOMLIB:String = 'loomlib is invalid';

        /** indicates provided file was unable to be parsed as a loomlib */
        public static const PARSE_FAIL:String = 'loomlib failed to parse';

        /** indicates the selected processor failed to complete */
        public static const PROCESSOR_FAIL:String = 'processor failed';

        /** indicates a file was unable to be written to the file system */
        public static const WRITE_FAIL:String = 'unable to write file';


        /** create a new `LSDocError` of type `DELETE_FAIL` */
        public static function deleteFail(msg:String):LSDocError
        {
            return new LSDocError(msg, DELETE_FAIL);
        }

        /** create a new `LSDocError` of type `DIR_FAIL` */
        public static function dirFail(msg:String):LSDocError
        {
            return new LSDocError(msg, DIR_FAIL);
        }

        /** create a new `LSDocError` of type `DIR_NOT_FOUND` */
        public static function noDir(msg:String):LSDocError
        {
            return new LSDocError(msg, DIR_NOT_FOUND);
        }

        /** create a new `LSDocError` of type `FILE_NOT_FOUND` */
        public static function noFile(msg:String):LSDocError
        {
            return new LSDocError(msg, FILE_NOT_FOUND);
        }

        /** create a new `LSDocError` of type `INVALID_LOOMLIB` */
        public static function badLib(msg:String):LSDocError
        {
            return new LSDocError(msg, INVALID_LOOMLIB);
        }

        /** create a new `LSDocError` of type `PARSE_FAIL` */
        public static function parseFail(msg:String):LSDocError
        {
            return new LSDocError(msg, PARSE_FAIL);
        }

        /** create a new `LSDocError` of type `PROCESSOR_FAIL` */
        public static function processorFail(msg:String):LSDocError
        {
            return new LSDocError(msg, PROCESSOR_FAIL);
        }

        /** create a new `LSDocError` of type `WRITE_FAIL` */
        public static function writeFail(msg:String):LSDocError
        {
            return new LSDocError(msg, WRITE_FAIL);
        }

        private var _type:String;


        /**
        Creates a new error object for the provided message and type

        @param message Details that may be useful in troubleshooting the error
        @param type Error identifier. Factory methods on this class use the class constants.
        */
        public function LSDocError(message:String, type:String):void
        {
            super(message);
            _type = type;
        }

        /** retrieve the error classification */
        public function get type():String { return _type; }

        /** retrieve a human readable description of the error */
        public function toString():String { return _type + ': ' +super.toString(); }
    }
}
