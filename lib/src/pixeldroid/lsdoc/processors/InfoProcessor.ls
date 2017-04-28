package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.lsdoc.processors.LSDocProcessor;

    public class InfoProcessor implements LSDocProcessor
    {
        public function execute(lsdoc:LSDoc):Vector.<LSDocError>
        {
            var err:Vector.<LSDocError> = [];

            for each(var m:ModuleInfo in lsdoc.modules)
            {
                trace(m);
                for each(var t:TypeInfo in m.types) trace(' ', t);
            }
            trace(getNumTypes(lsdoc), 'total types');

            return err;
        }

        public function getNumTypes(lsdoc:LSDoc):Number
        {
            var n:Number = 0;
            for each(var m:ModuleInfo in lsdoc.modules) n += m.types.length;

            return n;
        }
    }
}
