package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.MetaInfo;
    // import pixeldroid.lsdoc.models.ParameterInfo;
    // import pixeldroid.lsdoc.models.TemplateTypes;


    /**
    Provides access to properties and members of a loomlib Method definition.
    */
    public class FunctionInfo
    {
        public var docString:String;
        public var isDefault:Boolean = true;
        // public var metaInfo:MetaInfo;
        public const methodAttributes:Vector.<String> = [];
        public var name:String;
        //public var parameters:Vector.<ParameterInfo>;
        public var returnTypeString:String;
        public var sourceFile:String;
        public var sourceLine:Number;
        // public var templateTypes:TemplateTypes;
        public var type:String;


        public function toString():String { return name; }


        public static function fromJSON(j:JSON):FunctionInfo
        {
            var m:FunctionInfo = new FunctionInfo();

            m.docString = j.getString('docString');
            m.isDefault = j.getBoolean('defaultconstructor');
            // m.metaInfo -> j.getObject('metainfo');
            LibUtils.extractStringVector(j.getArray('methodattributes'), m.methodAttributes);
            m.name = j.getString('name');
            // m.parameters -> j.getArray('parameters');
            m.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), m.returnTypeString);
            m.sourceLine = j.getNumber('line');
            // m.templateTypes -> j.getObject('templatetypes')
            m.type = j.getString('type');

            if (m.type == 'METHOD')
                m.returnTypeString = j.getString('returntype');

            return m;
        }

    }
}
