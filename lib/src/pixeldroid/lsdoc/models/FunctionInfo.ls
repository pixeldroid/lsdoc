package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.MetaInfo;
    import pixeldroid.lsdoc.models.ParamInfo;
    // import pixeldroid.lsdoc.models.TemplateType;


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
        public var parameters:Vector.<ParamInfo> = [];
        public var returnTypeString:String;
        public var sourceFile:String;
        public var sourceLine:Number;
        public var templateTypes:TemplateType;
        public var type:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):FunctionInfo
        {
            var f:FunctionInfo = new FunctionInfo();

            f.docString = j.getString('docString');
            f.isDefault = j.getBoolean('defaultconstructor');
            // f.metaInfo -> j.getObject('metainfo');
            LibUtils.extractStringVector(j.getArray('methodattributes'), f.methodAttributes);

            f.name = (f.methodAttributes.contains('operator')) ?
                FunctionInfo.methodOperators[j.getString('name')] : j.getString('name');

            var pj:JSON = j.getArray('parameters');
            var n:Number = pj.getArrayCount();
            for (var i:Number = 0; i < n; i++)
               f.parameters.push(ParamInfo.fromJSON(pj.getArrayObject(i)));

            f.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), f.returnTypeString);
            f.sourceLine = j.getNumber('line');
            f.type = j.getString('type');

            var tj:JSON = j.getObject('templatetypes');
            if (tj)
                f.templateTypes = TemplateType.fromJSON(tj);

            if (f.type == 'METHOD')
                f.returnTypeString = j.getString('returntype');

            return f;
        }

    }
}
