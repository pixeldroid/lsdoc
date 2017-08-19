package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.models.TemplateType;


    /**
    Provides access to properties and members of a loomlib method parameter.
    */
    public class ParamInfo
    {
        public var defaultValue:String;
        public var hasDefault:Boolean = true;
        public var isVarArgs:Boolean = false;
        public var name:String;
        public var templateTypes:TemplateType;
        public var typeString:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):ParamInfo
        {
            var p:ParamInfo = new ParamInfo();
            var jj:JSON;

            p.hasDefault = j.getBoolean('hasdefault');

            if (p.hasDefault)
                p.defaultValue = j.getString('defaultvalue');

            p.isVarArgs = j.getBoolean('isvarargs');
            p.name = j.getString('name');

            if (jj = j.getObject('templatetypes'))
                p.templateTypes = TemplateType.fromJSON(jj);

            p.typeString = j.getString('type');

            return p;
        }

    }
}
