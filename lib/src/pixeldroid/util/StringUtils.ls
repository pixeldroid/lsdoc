package pixeldroid.util
{

    /**
        A utlity class for manipulating strings.
    */
    public final class StringUtils
    {

        private static function part(s:String, token:String, rightPart:Boolean = false):String
        {
            if (!token || !s)
                return rightPart ? '' : s;

            var i:Number = s.indexOf(token);
            if (i == -1)
                return rightPart ? '' : s;

            var n:Number = s.length;
            if (i > 0 && i+1 < n)
                return rightPart ? s.substring(i+1, n) : s.substring(0, i);

            return '';
        }

        /**
        Searches string for token. If found, returns characters after token. If not found, returns the empty string.

        If the token ends the string, return value will be the empty string.
        */
        public static function after(s:String, token:String):String { return part(s, token, true); }

        /**
        Searches string for token. If found, returns characters before token. If not found, returns original string.

        If the token starts the string, return value will be the empty string.
        */
        public static function before(s:String, token:String):String { return part(s, token, false); }

        public static function startsWith(s:String, token:String):Boolean
        {
            if (!token || !s)
                return false;

            return (s.indexOf(token) == 0);
        }

        public static function endsWith(s:String, token:String):Boolean
        {
            if (!token || !s)
                return false;

            return (s.indexOf(token) == (s.length - token.length));
        }
    }
}
