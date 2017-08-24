package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib `field` declaration.
    */
    public class TypeField
    {
        public var docString:String;
        // public var metaInfo:ElementMetaData;
        public const fieldAttributes:Vector.<String> = [];
        public var name:String;
        public var templateTypes:ValueTemplate;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):TypeField
        {
            var f:TypeField = new TypeField();

            f.docString = j.getString('docString');
            // f.metaInfo -> j.getObject('metainfo');
            LibUtils.extractStringVector(j.getArray('fieldattributes'), f.fieldAttributes);
            f.name = j.getString('name');
            f.typeString = j.getString('type');

            var tj:JSON = j.getObject('templatetypes');
            if (tj)
                f.templateTypes = ValueTemplate.fromJSON(tj);

            return f;
        }

    }
}
