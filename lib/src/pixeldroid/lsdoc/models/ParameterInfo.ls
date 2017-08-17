package pixeldroid.lsdoc.models
{
    import system.JSON;

    // import pixeldroid.lsdoc.models.TemplateType;


    /**
    Provides access to properties and members of a loomlib method parameter.
    */
    public class ParamInfo
    {
        public var defaultValue:String;
        public var hasDefault:Boolean = true;
        public var isVarArgs:Boolean = false;
        public var name:String;
        // public var templateTypes:TemplateType;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):ParamInfo
        {
            var m:ParamInfo = new ParamInfo();

            m.hasDefault = j.getBoolean('hasdefault');

            if (m.hasDefault)
                m.defaultValue = j.getString('defaultvalue');

            m.isVarArgs = j.getBoolean('isvarargs');
            m.name = j.getString('name');
            // m.templateTypes = TemplateType.fromJSON(j.getObject('templatetypes'));
            m.typeString = j.getString('type');

            return m;
        }

    }
}
