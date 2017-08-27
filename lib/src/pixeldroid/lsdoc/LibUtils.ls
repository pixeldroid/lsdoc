package pixeldroid.lsdoc
{
    import system.JSON;
    import system.JSONType;


    public final class LibUtils
    {
        /**
        Extracts JSON array elements, sends them through a transformation function, and stores them in a provided Vector.
        */
        public static function extractTypeVector(j:JSON, f:Function, v:Vector.<Object>):void
        {
            if (j.getJSONType() != JSONType.JSON_ARRAY)
                return;

            var n:Number = j.getArrayCount();
            for (var i:Number = 0; i < n; i++)
               v.push(f(j.getArrayObject(i)));
        }

        /**
        Inserts the contents of a JSON string array into a `Vector.<String>`
        */
        public static function extractStringVector(j:JSON, v:Vector.<String>):void
        {
            if (j.getJSONType() != JSONType.JSON_ARRAY)
                return;

            var n:Number = j.getArrayCount();
            for (var i:Number = 0; i < n; i++)
                v.push(j.getArrayString(i));
        }

        /**
        Remove non-package path cruft from source file path.

        Source file paths in loomlibs typically have two characteristics we remove here:
          - start with a containing directory that is not part of the package namespace
          - contain an empty directory as part of the filepath

        E.g.: we convert: `'./src//package/subpackage/Type.ls'`
                    into: `'package/subpackage/Type.ls'`
        */
        public static function cleanSourcePath(sourcePath:String, packageString:String):String
        {
            var rootPackage:String = packageString.split('.').shift();
            var start:Number = sourcePath.indexOf(rootPackage);
            var result:String;

            result = sourcePath.substring(start, sourcePath.length);
            result = result.split('//').join('/');

            return result;
        }
    }
}
