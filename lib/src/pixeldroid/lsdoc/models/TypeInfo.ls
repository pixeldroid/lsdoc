package pixeldroid.lsdoc.models
{
    import system.JSON;

    // import pixeldroid.lsdoc.models.FieldInfo;
    // import pixeldroid.lsdoc.models.MetaInfo;
    // import pixeldroid.lsdoc.models.MethodInfo;
    // import pixeldroid.lsdoc.models.PropertyInfo;


    public class TypeInfo
    {
        public var baseTypeString:String;
        public const classAttributes:Vector.<String> = [];
        //public var constructor:MethodInfo;
        public var delegateReturnTypeString:String;
        public const delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        //public var fields:Vector.<FieldInfo>;
        public const interfaceStrings:Vector.<String> = [];
        //public const metaInfo:Vector.<MetaInfo> = [];
        //public var methods:Vector.<MethodInfo>;
        public var name:String;
        public var packageString:String;
        //public var properties:Vector.<PropertyInfo>;
        public var sourceFile:String;
        public var construct:String;

        public function TypeInfo():void
        {
        }

        public function toString():String { return packageString +'.' +name; }

        public static function fromJSON(j:JSON):TypeInfo
        {
            var t:TypeInfo = new TypeInfo();

            t.name = j.getString('name');
            t.baseTypeString = j.getString('baseType');
            extractStringVector(j.getArray('classattributes'), t.classAttributes);
            t.delegateReturnTypeString = j.getString('delegateReturnType');
            extractStringVector(j.getArray('delegateTypes'), t.delegateTypeStrings);
            t.docString = j.getString('docString');
            extractStringVector(j.getArray('interfaces'), t.interfaceStrings);
            t.packageString = j.getString('package');
            t.sourceFile = cleanSourcePath(j.getString('source'), t.packageString);
            t.construct = j.getString('type');

            return t;
        }


        private static function extractStringVector(j:JSON, v:Vector.<String>):void
        {
            var n:Number = j.getArrayCount();
            for (var i:Number = 0; i < n; i++) v.push(j.getArrayString(i));
        }

        private static function cleanSourcePath(sourcePath:String, packageString:String):String
        {
            /*
            source file paths in loomlibs typically have two characteristics we remove here:
              - start with a containing directory that is not part of the package namespace
              - contain an empty directory as part of the filepath

            E.g.: we convert: './src//package/subpackage/Type.ls'
                        into: 'package/subpackage/Type.ls'
            */

            var rootPackage:String = packageString.split('.').shift();
            var start:Number = sourcePath.indexOf(rootPackage);
            var result:String;

            result = sourcePath.substring(start, sourcePath.length);
            result = result.split('//').join('/');

            return result;
        }

    }
}
