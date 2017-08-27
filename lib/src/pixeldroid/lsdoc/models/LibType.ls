package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.TypeField;
    import pixeldroid.lsdoc.models.TypeMethod;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.TypeProperty;


    /**
    Encapsulates the data of a loomlib `type` declaration.

    @see DefinitionConstruct
    */
    public class LibType
    {
        public var baseTypeString:String;
        public var attributes:Vector.<String> = [];
        public var construct:String;
        public var constructor:TypeMethod;
        public var delegateReturnTypeString:String;
        public var delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        public var fields:Vector.<TypeField> = [];
        public var interfaceStrings:Vector.<String> = [];
        //public var metaInfo:ElementMetaData;
        public var methods:Vector.<TypeMethod> = [];
        public var name:String;
        public var packageString:String;
        public var properties:Vector.<TypeProperty> = [];
        public var sourceFile:String;

        public function toString():String { return packageString +'.' +name; }

        public static function fromJSON(j:JSON):LibType
        {
            var t:LibType = new LibType();
            var jj:JSON;

            t.name = j.getString('name');
            t.construct = j.getString('type');

            t.baseTypeString = j.getString('baseType');

            if (jj = j.getArray('classattributes'))
                LibUtils.extractStringVector(jj, t.attributes);

            t.delegateReturnTypeString = j.getString('delegateReturnType');

            if (jj = j.getArray('delegateTypes'))
                LibUtils.extractStringVector(jj, t.delegateTypeStrings);

            t.docString = j.getString('docString');

            if (jj = j.getArray('interfaces'))
                LibUtils.extractStringVector(jj, t.interfaceStrings);

            t.packageString = j.getString('package');
            t.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), t.packageString);

            switch(DefinitionConstruct.fromString(t.construct))
            {
                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    t.constructor = TypeMethod.fromJSON(j.getObject('constructor'));
                    t.constructor.returnTypeString = t.packageString +'.' +t.name;
                    break;
            }

            if (jj = j.getArray('methods'))
                LibUtils.extractTypeVector(jj, TypeMethod.fromJSON, t.methods);

            if (jj = j.getArray('fields'))
                LibUtils.extractTypeVector(jj, TypeField.fromJSON, t.fields);

            if (jj = j.getArray('properties'))
                LibUtils.extractTypeVector(jj, TypeProperty.fromJSON, t.properties);

            return t;
        }

    }
}
