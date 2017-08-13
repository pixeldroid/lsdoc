package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    // import pixeldroid.lsdoc.models.FieldInfo;
    import pixeldroid.lsdoc.models.FunctionInfo;
    // import pixeldroid.lsdoc.models.MetaInfo;
    // import pixeldroid.lsdoc.models.PropertyInfo;


    /**
    Provides access to properties and members of a loomlib Type definition.

    @see DefinitionConstruct
    */
    public class TypeInfo
    {
        public var baseTypeString:String;
        public const classAttributes:Vector.<String> = [];
        public var construct:String;
        public var constructor:FunctionInfo;
        public var delegateReturnTypeString:String;
        public const delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        //public var fields:Vector.<FieldInfo>;
        public const interfaceStrings:Vector.<String> = [];
        //public var metaInfo:MetaInfo;
        //public var methods:Vector.<FunctionInfo>;
        public var name:String;
        public var packageString:String;
        //public var properties:Vector.<PropertyInfo>;
        public var sourceFile:String;

        public function toString():String { return packageString +'.' +name; }

        public static function fromJSON(j:JSON):TypeInfo
        {
            var t:TypeInfo = new TypeInfo();

            t.name = j.getString('name');
            t.construct = j.getString('type');

            t.baseTypeString = j.getString('baseType');
            LibUtils.extractStringVector(j.getArray('classattributes'), t.classAttributes);
            t.delegateReturnTypeString = j.getString('delegateReturnType');
            LibUtils.extractStringVector(j.getArray('delegateTypes'), t.delegateTypeStrings);
            t.docString = j.getString('docString');
            LibUtils.extractStringVector(j.getArray('interfaces'), t.interfaceStrings);
            t.packageString = j.getString('package');
            t.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), t.packageString);

            var construct:DefinitionConstruct = DefinitionConstruct.fromString(t.construct);
            switch(construct)
            {
                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    t.constructor = FunctionInfo.fromJSON(j.getObject('constructor'));
                    t.constructor.returnTypeString = t.packageString +'.' +t.name;
                    break;
            }

            return t;
        }

    }
}
