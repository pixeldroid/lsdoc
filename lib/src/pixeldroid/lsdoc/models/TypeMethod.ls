package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.MethodParameter;
    import pixeldroid.lsdoc.models.ValueTemplate;


    /**
    Encapsulates the data of a loomlib `method` declaration.

    This includes overloaded operator definitions.
    */
    public class TypeMethod
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
        // public var metaInfo:ElementMetaData;
        public const attributes:Vector.<String> = [];
        public var name:String;
        public var parameters:Vector.<MethodParameter> = [];
        public var returnTypeString:String;
        public var sourceFile:String;
        public var sourceLine:Number;
        public var templateTypes:ValueTemplate;
        public var type:String;

        public function toString():String { return name; }


        public static function fromJSON(j:JSON):TypeMethod
        {
            var f:TypeMethod = new TypeMethod();

            f.docString = j.getString('docString');
            f.isDefault = j.getBoolean('defaultconstructor');
            // f.metaInfo -> j.getObject('metainfo');
            LibUtils.extractStringVector(j.getArray('methodattributes'), f.attributes);

            f.name = (f.attributes.contains('operator')) ?
                TypeMethod.methodOperators[j.getString('name')] : j.getString('name');

            var pj:JSON = j.getArray('parameters');
            var n:Number = pj.getArrayCount();
            for (var i:Number = 0; i < n; i++)
               f.parameters.push(MethodParameter.fromJSON(pj.getArrayObject(i)));

            f.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), f.returnTypeString);
            f.sourceLine = j.getNumber('line');
            f.type = j.getString('type');

            var tj:JSON = j.getObject('templatetypes');
            if (tj)
                f.templateTypes = ValueTemplate.fromJSON(tj);

            if (f.type == 'METHOD')
                f.returnTypeString = j.getString('returntype');

            return f;
        }

    }
}
