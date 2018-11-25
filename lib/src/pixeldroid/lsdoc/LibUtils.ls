package pixeldroid.lsdoc
{
    import system.JSON;
    import system.JSONType;


    /**
        A utlity class for working with common loomlib JSON structures.
    */
    public final class LibUtils
    {
        /**
        Extracts elements of a JSON object array and sends them to a provided function.

        The provided function is called once for each element in the JSON array.
        */
        public static function applyToJSONArray(j:JSON, f:Function):void
        {
            if (j.getJSONType() != JSONType.JSON_ARRAY)
                return;

            var n:Number = j.getArrayCount();
            for (var i:Number = 0; i < n; i++)
                f(j.getArrayObject(i));
        }

        /**
        Extracts elements of a JSON object array, sends them through a transformation function, and loads the result into a provided vector.

        Elements are pushed onto the end of the vector in the same order as the provided JSON array.
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
        Copies the contents of a JSON string array into a `Vector.<String>`.

        _Note:_ The provided string vector is not cleared; items are pushed onto the end.
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

        e.g.: we convert: `'./src//package/subpackage/Type.ls'`
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
