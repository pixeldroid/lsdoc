package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.LibType;
    import pixeldroid.platform.StringUtils;


    /**
    Encapsulates the data of a loomlib `module` declaration.
    */
    public class LibModule
    {

        private var _types:Vector.<LibType> = [];
        private var _typeDictionary:Dictionary.<String, LibType> = {};

        public var name:String;
        public var version:String;

        public function toString():String { return name +' v' +version +' (' +_types.length +' types)'; }

        public function get types():Vector.<LibType> { return _types; }

        public function addType(t:LibType):Number
        {
            _typeDictionary[t.typeString] = t;
            _types.push(t);

            return _types.length;
        }

        public function fetchType(typeString:String, defaultValue:Object = null):LibType { return _typeDictionary.fetch(typeString, defaultValue) as LibType; }


        public static function fromJSON(j:JSON):LibModule
        {
            var m:LibModule = new LibModule();
            var f:Function = function (j:JSON):void { m.addType(LibType.fromJSON(j)); }; // capture m in closure
            var jj:JSON;

            m.name = j.getString('name');
            m.version = j.getString('version');

            if (jj = j.getArray('types'))
                LibUtils.applyToJSONArray(jj, f);

            return m;
        }

        public static function selectTypesByPackage(parentPackage:String, typeList:Vector.<LibType>):Vector.<LibType>
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

        public static function selectTypesByConstruct(construct:DefinitionConstruct, typeList:Vector.<LibType>):Vector.<LibType>
        {
            var result:Vector.<LibType> = [];

            for each(var t:LibType in typeList)
            {
                if (t.construct == construct.name)
                    result.push(t);
            }

            return result;
        }

        public static function getPackages(module:LibModule):Vector.<String>
        {
            var p:Vector.<String> = [];
            var s:String;

            for each(var t:LibType in module.types)
            {
                s = t.packageString;
                if (s == '' || p.contains(s))
                    continue;

                p.push(s);
            }

            return p;
        }

        public static function getSubpackages(parentPackage:String, module:LibModule):Vector.<String>
        {
            var subPackages:Vector.<String> = [];
            var typePackage:String;
            var parentComponents:Vector.<String> = [];
            var typeComponents:Vector.<String> = [];

            for each(var t:LibType in module.types)
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

        public static function getAncestors(subject:LibType, module:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];
            var ancestor:String = subject.baseTypeString;

            while (ancestor != '')
            {
                result.push(ancestor);

                if (!(subject = module.fetchType(ancestor)))
                    break;

                ancestor = subject.baseTypeString;
            }

            return result;
        }

        public static function getImplementors(fullName:String, module:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];

            for each(var t:LibType in module.types)
            {
                if (t.interfaceStrings.contains(fullName))
                    result.push(t.toString());
            }

            return result;
        }

        public static function getSubClasses(fullName:String, module:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];

            for each(var t:LibType in module.types)
            {
                if (t.baseTypeString == fullName)
                    result.push(t.toString());
            }

            return result;
        }

        public static function getDescendants(subject:LibType, module:LibModule):Vector.<String>
        {
            var result:Vector.<String>;
            var fullName:String = subject.toString();
            var construct:DefinitionConstruct = DefinitionConstruct.fromString(subject.construct);

            switch(construct)
            {
                case DefinitionConstruct.INTERFACE:
                    result = getImplementors(fullName, module);
                    break;

                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    result = getSubClasses(fullName, module);
                    break;

                default:
                    result = [];
                    break;
            }

            return result;
        }

    }
}
