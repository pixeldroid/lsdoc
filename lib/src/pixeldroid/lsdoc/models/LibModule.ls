package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.platform.StringUtils;


    /**
    Encapsulates the data of a loomlib `module` declaration.
    */
    public class LibModule
    {

        public var name:String;
        public var types:Vector.<LibType> = [];
        public var version:String;

        public function toString():String { return name +'(' +types.length +' types)'; }


        public static function fromJSON(j:JSON):LibModule
        {
            var m:LibModule = new LibModule();

            m.name = j.getString('name');
            m.version = j.getString('version');
            var mTypes:Vector.<LibType> = m.types;
            var jTypes:JSON = j.getArray('types');
            var numTypes:Number = jTypes.getArrayCount();
            for (var i:Number = 0; i < numTypes; i++)
            {
                mTypes.push(LibType.fromJSON(jTypes.getArrayObject(i)));
            }

            return m;
        }

        public static function getTypeByName(fullName:String, typeList:Vector.<LibType>):LibType
        {
            for each(var t:LibType in typeList)
            {
                if (t.toString() == fullName)
                    return t;
            }

            return null;
        }

        public static function getTypesByPackage(typeList:Vector.<LibType>, parentPackage:String):Vector.<LibType>
        {
            var result:Vector.<LibType> = [];
            var typePackage:String;

            for each(var t:LibType in typeList)
            {
                typePackage = t.packageString;

                if (parentPackage == typePackage)
                    result.push(t); // child of parent package

                else if (parentPackage == '' && typePackage.indexOf('.') == -1)
                    result.push(t); // top level
            }

            return result;
        }

        public static function getTypesByConstruct(typeList:Vector.<LibType>, construct:DefinitionConstruct):Vector.<LibType>
        {
            var result:Vector.<LibType> = [];

            for each(var t:LibType in typeList)
            {
                if (t.construct == construct.name)
                    result.push(t);
            }

            return result;
        }

        public static function getPackages(typeList:Vector.<LibType>):Vector.<String>
        {
            var p:Vector.<String> = [];
            var s:String;

            for each(var t:LibType in typeList)
            {
                s = t.packageString;
                if (s == '' || p.contains(s))
                    continue;

                p.push(s);
            }

            return p;
        }

        public static function getSubpackages(typeList:Vector.<LibType>, parentPackage:String):Vector.<String>
        {
            var subPackages:Vector.<String> = [];
            var typePackage:String;
            var parentComponents:Vector.<String> = [];
            var typeComponents:Vector.<String> = [];

            for each(var t:LibType in typeList)
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

        public static function getAncestors(subject:LibType, typeList:Vector.<LibType>):Vector.<String>
        {
            var result:Vector.<String> = [];
            var ancestor:String = subject.baseTypeString;

            while (ancestor != '')
            {
                result.push(ancestor);

                if (!(subject = getTypeByName(ancestor, typeList)))
                    break;

                ancestor = subject.baseTypeString;
            }

            return result;
        }

        public static function getImplementors(fullName:String, typeList:Vector.<LibType>):Vector.<String>
        {
            var result:Vector.<String> = [];

            for each(var t:LibType in typeList)
            {
                if (t.interfaceStrings.contains(fullName))
                    result.push(t.toString());
            }

            return result;
        }

        public static function getSubClasses(fullName:String, typeList:Vector.<LibType>):Vector.<String>
        {
            var result:Vector.<String> = [];

            for each(var t:LibType in typeList)
            {
                if (t.baseTypeString == fullName)
                    result.push(t.toString());
            }

            return result;
        }

        public static function getDescendants(subject:LibType, typeList:Vector.<LibType>):Vector.<String>
        {
            var result:Vector.<String>;
            var fullName:String = subject.toString();
            var construct:DefinitionConstruct = DefinitionConstruct.fromString(subject.construct);

            switch(construct)
            {
                case DefinitionConstruct.INTERFACE:
                    result = getImplementors(fullName, typeList);
                    break;

                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    result = getSubClasses(fullName, typeList);
                    break;

                default:
                    result = [];
                    break;
            }

            return result;
        }

    }
}
