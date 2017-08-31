package pixeldroid.lsdoc.models
{


    /**
    Encapsulates the data of an doc tag (`@tag`).
    */
    public class DocTag
    {
        private static const NAME_DELIMITER:String = '@';
        private static const VALUE_DELIMITER:String = ' ';
        private static const LINE_DELIMITER:String = '\n';

        private const _name:String;
        private const _value:String;


        public function DocTag(name:String, value:String)
        {
            _name = name;
            _value = value;
        }

        public static function selectByTagName(sourceList:Vector.<DocTag>, tagName:String, targetList:Vector.<DocTag>, findNonMatches:Boolean = false):Boolean
        {
            var anyFound:Boolean = false;

            if (!targetList)
                return anyFound;

            var isMatch:Boolean = false;
            for each(var tag in sourceList)
            {
                isMatch = (tag.name == tagName);
                if ((isMatch && !findNonMatches) || (!isMatch && findNonMatches))
                {
                    anyFound = true;
                    targetList.push(tag);
                }
            }

            return anyFound;
        }

        public static function fromRawField(field:String, targetList:Vector.<DocTag>):String
        {
            var nonTag:String = '';

            if (!targetList)
                return nonTag;

            var lines:Vector.<String> = field.split(LINE_DELIMITER);
            var tag:DocTag;

            for each(var line:String in lines)
            {
                if (line.indexOf(NAME_DELIMITER) < 0)
                {
                    nonTag += (line +LINE_DELIMITER);
                    continue;
                }

                if ((tag = fromRawLine(line)) == null)
                    continue;

                targetList.push(tag);
            }

            return nonTag;
        }

        public static function fromRawLine(line:String):DocTag
        {
            var trimmedLine = line.trim();

            var ni:Number = trimmedLine.indexOf(NAME_DELIMITER);
            var vi:Number = trimmedLine.indexOf(VALUE_DELIMITER);

            if (ni != 0 || vi < 0)
                return null;

            var n:String = trimmedLine.substring(ni+1, vi);
            var v:String = trimmedLine.substring(vi+1, trimmedLine.length);

            return new DocTag(n, v);
        }


        /**
        Provides a human-readable string representation of the tag.

        e.g.: `@<name> <value>`
        */
        public function toString():String { return NAME_DELIMITER +_name +VALUE_DELIMITER +_value; }

        public function get name():String { return _name; }

        public function get value():String { return _value; }

    }
}
