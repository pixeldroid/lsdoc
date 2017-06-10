package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;


    public class ProcessingContext
    {
        public var lsdoc:LSDoc;
        public var errors:Vector.<LSDocError> = [];
        public var outDir:String;

        public function appendErrors(errors:Vector.<LSDocError>):void
        {
            this.errors = this.errors.concat(errors);
        }

        public function get hasErrors():Boolean
        {
            return (errors.length > 0);
        }
    }
}
