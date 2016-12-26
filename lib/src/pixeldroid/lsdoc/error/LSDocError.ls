package pixeldroid.lsdoc.error
{
    import system.errors.Error;


    public class LSDocError extends Error
    {

        public static const DIR_NOT_FOUND:String = 'directory not found';
        public static const FILE_NOT_FOUND:String = 'file not found';

        private var _type:String;


        public function LSDocError(message:String, type:String):void
        {
            super(message);
            _type = type;
        }

        public function get type():String { return _type; }
    }
}
