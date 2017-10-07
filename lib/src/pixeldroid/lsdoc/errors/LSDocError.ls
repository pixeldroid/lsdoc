package pixeldroid.lsdoc.errors
{
    import system.errors.Error;


    /**
    Provides error codes and messages for problems that might be encountered during docs generation.
    */
    public class LSDocError extends Error
    {

        public static const DELETE_FAIL:String = 'unable to write file';
        public static const DIR_FAIL:String = 'unable to create directory';
        public static const DIR_NOT_FOUND:String = 'directory not found';
        public static const FILE_NOT_FOUND:String = 'file not found';
        public static const INVALID_LOOMLIB:String = 'loomlib is invalid';
        public static const PARSE_FAIL:String = 'loomlib failed to parse';
        public static const PROCESSOR_FAIL:String = 'processor failed';
        public static const WRITE_FAIL:String = 'unable to write file';

        public static function deleteFail(msg:String):LSDocError
        {
            return new LSDocError(msg, DELETE_FAIL);
        }

        public static function dirFail(msg:String):LSDocError
        {
            return new LSDocError(msg, DIR_FAIL);
        }

        public static function noDir(msg:String):LSDocError
        {
            return new LSDocError(msg, DIR_NOT_FOUND);
        }

        public static function noFile(msg:String):LSDocError
        {
            return new LSDocError(msg, FILE_NOT_FOUND);
        }

        public static function badLib(msg:String):LSDocError
        {
            return new LSDocError(msg, INVALID_LOOMLIB);
        }

        public static function parseFail(msg:String):LSDocError
        {
            return new LSDocError(msg, PARSE_FAIL);
        }

        public static function processorFail(msg:String):LSDocError
        {
            return new LSDocError(msg, PROCESSOR_FAIL);
        }

        public static function writeFail(msg:String):LSDocError
        {
            return new LSDocError(msg, WRITE_FAIL);
        }

        private var _type:String;


        public function LSDocError(message:String, type:String):void
        {
            super(message);
            _type = type;
        }

        public function get type():String { return _type; }

        public function toString():String { return _type + ': ' +super.toString(); }
    }
}
