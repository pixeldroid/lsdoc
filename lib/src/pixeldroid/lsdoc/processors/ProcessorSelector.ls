package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.processors.GHPagesProcessor;
    import pixeldroid.lsdoc.processors.InfoProcessor;
    import pixeldroid.lsdoc.processors.LSDocProcessor;

    public class ProcessorSelector
    {
        private static const types:Vector.<Type> = [
            GHPagesProcessor,
            InfoProcessor
        ];


        public static function select(name:String):LSDocProcessor
        {
            var selectedType:Type = InfoProcessor;

            for each(var t:Type in types)
            {
                if (name == selectionName(t))
                {
                    selectedType = t;
                    break;
                }
            }

            var processor:LSDocProcessor = selectedType.getConstructor().invoke() as LSDocProcessor;
            return processor;
        }

        public static function get selectionNames():Vector.<String>
        {
            var names:Vector.<String> = [];

            for each(var t:Type in types)
            {
                names.push(selectionName(t));
            }

            return names;
        }


        private static function selectionName(t:Type):String
        {
            var s:String = t.getTypeName();
            s = s.substring(0, s.length - 'processor'.length);
            s = s.toLowerCase();

            return s;
        }
    }
}
