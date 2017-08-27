package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.TypeMethod;
    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib `property` declaration.

    Loom properties are special methods that look like a field, but provide control over access and mutation:
      - `function get foo()`
      - `function set foo()` (optional, value is read-only when not defined)

    Note that doc strings are only recorded from the getter definition.
    */
    public class TypeProperty
    {
        public var attributes:Vector.<String> = [];
        public var docString:String;
        public var getter:TypeMethod;
        public var isReadOnly:Boolean = false;
        // public var metaInfo:ElementMetaData;
        public var name:String;
        public var setter:TypeMethod;
        public var templateTypes:ValueTemplate;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):TypeProperty
        {
            var p:TypeProperty = new TypeProperty();
            var jj:JSON;

            p.docString = j.getString('docString');
            p.name = j.getString('name');
            p.typeString = j.getString('type');

            // p.metaInfo -> j.getObject('metainfo');

            if (jj = j.getArray('propertyattributes'))
                LibUtils.extractStringVector(jj, p.attributes);

            if (jj = j.getObject('getter'))
                p.getter = TypeMethod.fromJSON(jj);

            if (jj = j.getObject('setter'))
                p.setter = TypeMethod.fromJSON(jj);

            else
                p.isReadOnly = true;

            if (jj = j.getObject('templatetypes'))
                p.templateTypes = ValueTemplate.fromJSON(jj);

            return p;
        }

    }
}
