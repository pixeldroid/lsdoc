package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;

    public interface LSDocProcessor
    {
        public function execute(lsdoc:LSDoc):Vector.<LSDocError>;
    }
}
