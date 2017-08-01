package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.models.ClassAttribute;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.TypeInfo;
    import pixeldroid.platform.StringUtils;


    public class ModuleInfo
    {

        public var name:String;
        public var types:Vector.<TypeInfo> = [];
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

        public static function getTypesByPackage(typeList:Vector.<TypeInfo>, parentPackage:String):Vector.<TypeInfo>
        {
            var result:Vector.<TypeInfo> = [];
            var typePackage:String;

            for each(var t:TypeInfo in typeList)
            {
                typePackage = t.packageString;

                if (parentPackage == typePackage)
                    result.push(t); // child of parent package

                else if (parentPackage == '' && typePackage.indexOf('.') == -1)
                    result.push(t); // top level
            }

            return result;
        }

        public static function getTypesByConstruct(typeList:Vector.<TypeInfo>, construct:DefinitionConstruct):Vector.<TypeInfo>
        {
            var result:Vector.<TypeInfo> = [];

            for each(var t:TypeInfo in typeList)
            {
                if (t.construct == construct.name)
                    result.push(t);
            }

            return result;
        }

        public static function getPackages(typeList:Vector.<TypeInfo>):Vector.<String>
        {
            var p:Vector.<String> = [];
            var s:String;

            for each(var t:TypeInfo in typeList)
            {
                s = t.packageString;
                if (s == '' || p.contains(s))
                    continue;

                p.push(s);
            }

            return p;
        }

        public static function getSubpackages(typeList:Vector.<TypeInfo>, parentPackage:String):Vector.<String>
        {
            var subPackages:Vector.<String> = [];
            var typePackage:String;
            var parentComponents:Vector.<String> = [];
            var typeComponents:Vector.<String> = [];

            for each(var t:TypeInfo in typeList)
            {
                typePackage = t.packageString;

                if (parentPackage != '' && !StringUtils.startsWith(typePackage, parentPackage))
                    continue;

                typeComponents = typePackage.split('.');
                parentComponents = parentPackage.split('.');

                if (parentComponents.length >= typeComponents.length)
                    continue;

                typePackage = typeComponents[parentComponents.length];

                if (subPackages.contains(typePackage))
                    continue;

                subPackages.push(typePackage);
            }

            return subPackages;
        }

    }
}
