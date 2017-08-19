package pixeldroid.lsdoc.models
{
    import system.JSON;
    import system.JSONType;


    /**
    Provides type details for the items of a container type.

    Container types like `Vector` and `Dictionary` declare the type of their members.
    That information is reflected in the loomlib templatetypes field.
    */
    public class TemplateType
    {
        public var typeString:String;
        public var itemTypes:Vector.<TemplateType> = [];

        public function toString():String
        {
            var s:String = typeString;
            var t:Vector.<String>;

            if (itemTypes.length > 0)
            {
                s += '.<';

                t = [];
                for each(var it:TemplateType in itemTypes)
                    t.push(it.toString());

                s += t.join(',');
                s += '>';
            }

            return s;
        }


        public function TemplateType(type:String)
        {
            typeString = type;
        }


        public static function fromJSON(j:JSON):TemplateType
        {
            var t:TemplateType = new TemplateType(j.getString('type'));

            var ja:JSON = j.getArray('types');
            var n:Number = ja.getArrayCount();
            var it:TemplateType;
            var jt:JSONType;
            var jj:JSON;

            for (var i:Number = 0; i < n; i++)
            {
                jt = ja.getArrayJSONType(i);

                if (jt == JSONType.JSON_STRING)
                    it = new TemplateType(ja.getArrayString(i));

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
