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


        public var attributes:Vector.<String> = [];
        public var docString:String;
        public var isDefault:Boolean = true;
        // public var metaInfo:ElementMetaData;
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
            var jj:JSON;

            f.docString = j.getString('docString');
            f.isDefault = j.getBoolean('defaultconstructor');
            f.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), f.returnTypeString);
            f.sourceLine = j.getNumber('line');
            f.type = j.getString('type');

            // f.metaInfo -> j.getObject('metainfo');

            if (jj = j.getArray('methodattributes'))
                LibUtils.extractStringVector(jj, f.attributes);

            f.name = (f.attributes.contains('operator')) ?
                TypeMethod.methodOperators[j.getString('name')] : j.getString('name');

            if (jj = j.getArray('parameters'))
                LibUtils.extractTypeVector(jj, MethodParameter.fromJSON, f.parameters);

            if (jj = j.getObject('templatetypes'))
                f.templateTypes = ValueTemplate.fromJSON(jj);

            if (f.type == 'METHOD')
                f.returnTypeString = j.getString('returntype');

            return f;
        }

    }
}
