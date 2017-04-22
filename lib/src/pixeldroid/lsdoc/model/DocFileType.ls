package pixeldroid.lsdoc.model
{
    import pixeldroid.platform.File2;


    public class DocFileType
    {
        public static const CODE:DocFileType = new DocFileType('CODE', 1);
        public static const DOC:DocFileType = new DocFileType('DOC', 2);
        public static const MEDIA:DocFileType = new DocFileType('MEDIA', 3);
        public static const CODE_ASSEMBLY:DocFileType = new DocFileType('CODE_ASSEMBLY', 4);
        public static const DOC_ASSEMBLY:DocFileType = new DocFileType('DOC_ASSEMBLY', 5);
        public static const UNKNOWN:DocFileType = new DocFileType('UNKNOWN', -1);

        private static const TYPE_MAP:Dictionary.<String, DocFileType> = {
            'ls' : CODE,
            'md' : DOC,
            'gif' : MEDIA,
            'jpg' : MEDIA,
            'png' : MEDIA,
            'loomlib' : CODE_ASSEMBLY,
            'loomdoc' : DOC_ASSEMBLY
        };

        public static function getAllDocFileTypes():Vector.<DocFileType>
        {
            return [
                CODE,
                DOC,
                MEDIA,
                UNKNOWN
            ];
        }

        public static function getDocFileType(filepath:String):DocFileType
        {
            var type:DocFileType = TYPE_MAP.fetch(File2.extname(filepath), UNKNOWN) as DocFileType;
            return type;
        }

        public static function isAssembly(filepath:String):Boolean
        {
            var type:DocFileType = TYPE_MAP.fetch(File2.extname(filepath), UNKNOWN) as DocFileType;
            return (type == CODE_ASSEMBLY || type == DOC_ASSEMBLY);
        }

        public static function isDocFile(filepath:String):Boolean
        {
            return (getDocFileType(filepath) != UNKNOWN);
        }


        private var label:String;
        private var value:Number;

        public function DocFileType(label:String, value:Number)
        {
            this.label = label;
            this.value = value;
        }

        public function toString():String
        {
            return label;
        }

        public function toValue():Number
        {
            return value;
        }

    }

}
