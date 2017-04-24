package pixeldroid.lsdoc.errors
{
    import system.errors.Error;


    public class LSDocError extends Error
    {

        public static const FILE_NOT_FOUND:String = 'file not found';
        public static const INVALID_LOOMLIB:String = 'loomlib is invalid';
        public static const PARSE_FAIL:String = 'loomlib failed to parse';

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
