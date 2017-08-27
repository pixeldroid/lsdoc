package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DocTag;
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
        public var docTags:Vector.<DocTag> = [];
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
            var m:TypeMethod = new TypeMethod();
            var jj:JSON;

            m.docString = j.getString('docString');
            m.docString = DocTag.fromRawField(m.docString, m.docTags);
            m.isDefault = j.getBoolean('defaultconstructor');
            m.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), m.returnTypeString);
            m.sourceLine = j.getNumber('line');
            m.type = j.getString('type');

            // m.metaInfo -> j.getObject('metainfo');

            if (jj = j.getArray('methodattributes'))
                LibUtils.extractStringVector(jj, m.attributes);

            m.name = (m.attributes.contains('operator')) ?
                TypeMethod.methodOperators[j.getString('name')] : j.getString('name');

            if (jj = j.getArray('parameters'))
                LibUtils.extractTypeVector(jj, MethodParameter.fromJSON, m.parameters);

            if (jj = j.getObject('templatetypes'))
                m.templateTypes = ValueTemplate.fromJSON(jj);

            if (m.type == 'METHOD')
                m.returnTypeString = j.getString('returntype');

            return m;
        }

    }
}
