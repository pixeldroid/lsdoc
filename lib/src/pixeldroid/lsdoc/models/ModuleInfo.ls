package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.models.TypeInfo;


    public class ModuleInfo
    {

        public var name:String;
        public const types:Vector.<TypeInfo> = [];
        public var version:String;


        public function ModuleInfo():void
        {
        }

        public function toString():String { return name +'(' +types.length +' types)'; }

        public static function fromJSON(j:JSON):ModuleInfo
        {
            var m:ModuleInfo = new ModuleInfo();

            m.name = j.getString('name');
            m.version = j.getString('version');
            var mTypes:Vector.<TypeInfo> = m.types;

            var jTypes:JSON = j.getArray('types');
            var numTypes:Number = jTypes.getArrayCount();
            for (var i:Number = 0; i < numTypes; i++)
            {
                mTypes.push(TypeInfo.fromJSON(jTypes.getArrayObject(i)));
            }

            return m;
        }

    }
}
