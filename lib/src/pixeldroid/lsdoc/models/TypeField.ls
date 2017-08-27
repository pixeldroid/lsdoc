package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DocTag;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib `field` declaration.
    */
    public class TypeField
    {
        public var attributes:Vector.<String> = [];
        public var docString:String;
        public var docTags:Vector.<DocTag> = [];
        // public var metaInfo:ElementMetaData;
        public var name:String;
        public var templateTypes:ValueTemplate;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):TypeField
        {
            var f:TypeField = new TypeField();
            var jj:JSON;

            f.docString = j.getString('docString');
            f.docString = DocTag.fromRawField(f.docString, f.docTags);
            f.name = j.getString('name');
            f.typeString = j.getString('type');

            // f.metaInfo -> j.getObject('metainfo');

            if (jj = j.getArray('fieldattributes'))
                LibUtils.extractStringVector(jj, f.attributes);

            if (jj = j.getObject('templatetypes'))
                f.templateTypes = ValueTemplate.fromJSON(jj);

            return f;
        }

    }
}
