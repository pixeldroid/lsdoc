package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.LSDoc;

    public interface LSDocProcessor
    {
        public function execute(lsdoc:LSDoc):void;
    }
}
