package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.TypeMethod;
    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib `field` declaration.

    Note that doc strings are only recorded from the getter definition.
    */
    public class TypeProperty
    {
        public var docString:String;
        public var getter:TypeMethod;
        public var setter:TypeMethod;
        // public var metaInfo:ElementMetaData;
        public var name:String;
        public const propertyAttributes:Vector.<String> = [];
        public var templateTypes:ValueTemplate;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):TypeProperty
        {
            var p:TypeProperty = new TypeProperty();

            p.docString = j.getString('docString');
            // p.metaInfo -> j.getObject('metainfo');
            LibUtils.extractStringVector(j.getArray('propertyattributes'), p.propertyAttributes);
            p.name = j.getString('name');
            p.typeString = j.getString('type');

            var jj:JSON;

            jj = j.getObject('getter');
            if (jj)
                p.getter = TypeMethod.fromJSON(jj);

            jj = j.getObject('setter');
            if (jj)
                p.setter = TypeMethod.fromJSON(jj);

            jj = j.getObject('templatetypes');
            if (jj)
                p.templateTypes = ValueTemplate.fromJSON(jj);

            return p;
        }

    }
}
