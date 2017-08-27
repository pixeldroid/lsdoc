package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib method parameter, found in a `parameters` declaration.
    */
    public class MethodParameter
    {
        public var defaultValue:String;
        public var hasDefault:Boolean = true;
        public var isVarArgs:Boolean = false;
        public var name:String;
        public var templateTypes:ValueTemplate;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):MethodParameter
        {
            var p:MethodParameter = new MethodParameter();
            var jj:JSON;

            p.hasDefault = j.getBoolean('hasdefault');

            if (p.hasDefault)
                p.defaultValue = j.getString('defaultvalue');

            p.isVarArgs = j.getBoolean('isvarargs');
            p.name = j.getString('name');
            p.typeString = j.getString('type');

            if (jj = j.getObject('templatetypes'))
                p.templateTypes = ValueTemplate.fromJSON(jj);

            return p;
        }

    }
}
