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
        // ref: /loom/script/compiler/lsToken.cpp::getOperatorMethodName()
        private static const methodOperators:Dictionary.<String,String> = {
            '__op_assignment' : '=',
            '__op_plus' : '+',
            '__op_plusassignment' : '+=',
            '__op_minus' : '-',
            '__op_minusassignment' : '-=',
            '__op_multiply' : '*',
            '__op_multiplyassignment' : '*=',
            '__op_divide' : '/',
            '__op_divideassignment' : '/=',
            '__op_logicalnot' : '!',
        };


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
            m.name = (m.methodAttributes.contains('operator')) ?
                FunctionInfo.methodOperators[j.getString('name')] : j.getString('name');
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
