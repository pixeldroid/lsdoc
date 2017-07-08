package pixeldroid.platform
{

    /**
        A utlity class for manipulating strings.
    */
    public final class StringUtils
    {

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
