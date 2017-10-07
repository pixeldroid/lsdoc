package pixeldroid.lsdoc.models
{
    import system.JSON;
    import system.JSONType;


    /**
    Provides type details for the items of a loomlib `templatetypes` declaration.

    Container types like `Vector` and `Dictionary` declare the strict type of their members.
    */
    public class ValueTemplate
    {
        public var itemTypes:Vector.<ValueTemplate> = [];
        public var typeString:String;

        public function toString():String
        {
            var s:String = typeString;
            var t:Vector.<String>;

            if (itemTypes.length > 0)
            {
                s += '.<';

                t = [];
                for each(var it:ValueTemplate in itemTypes)
                    t.push(it.toString());

                s += t.join(',');
                s += '>';
            }

            return s;
        }


        public function ValueTemplate(type:String)
        {
            typeString = type;
        }


        public static function fromJSON(j:JSON):ValueTemplate
        {
            var t:ValueTemplate = new ValueTemplate(j.getString('type'));

            var ja:JSON = j.getArray('types');
            var n:Number = ja.getArrayCount();
            var it:ValueTemplate;
            var jt:JSONType;
            var jj:JSON;

            for (var i:Number = 0; i < n; i++)
            {
                jt = ja.getArrayJSONType(i);

                if (jt == JSONType.JSON_STRING)
                    it = new ValueTemplate(ja.getArrayString(i));

                if (jt == JSONType.JSON_OBJECT)
                {
                    if (jj = ja.getArrayObject(i))
                        it = fromJSON(jj);
                }

                t.itemTypes.push(it);
            }

            return t;
        }

    }
}
