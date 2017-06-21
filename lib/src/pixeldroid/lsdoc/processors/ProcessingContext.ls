package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;


    public class ProcessingContext
    {
        public var errors:Vector.<LSDocError> = [];
        public var lsdoc:LSDoc;
        public var opts:Dictionary.<String,Vector.<String>>;
        public var outPath:String;

        public function appendErrors(errors:Vector.<LSDocError>):void
        {
            this.errors = this.errors.concat(errors);
        }

        public function get hasErrors():Boolean
        {
            return (errors.length > 0);
        }

        public function getOption(longName:String, shortName:String, defaultValue:Vector.<String>):Vector.<String>
        {
            var v:Vector.<String>;

            if (v = opts.fetch(longName, null) as Vector.<String>)
                return v;

            if (v = opts.fetch(shortName, null) as Vector.<String>)
                return v;

            return defaultValue;
        }

        public function toString():String
        {
            var s:String = '';
            s += 'opts:\n' +dictToString(opts) +'\n';
            s += 'output path: "' +outPath +'"\n';
            s += errors.length +' error' +(errors.length != 1 ? 's' : '') +'.';
            return s;
        }


        private function dictToString(d:Dictionary.<String,Vector.<String>>, i:String = '  '):String
        {
            var s:Vector.<String> = [];
            var v:Vector.<String>;

            for (var k:String in d)
            {
                v = d[k];
                s.push(i +k +': [' +v.join(',') +']');
            }

            return s.join('\n');
        }
    }
}
