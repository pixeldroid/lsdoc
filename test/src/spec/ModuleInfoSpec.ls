package
{
    import system.platform.Path;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;


    public static class LibModuleSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('LibModule');

            it.should('select types by package membership', types_by_package);
            it.should('select types by construct', types_by_construct);
            it.should('collect all packages in a module', get_packages);
            it.should('collect all subpackages under a parent package in a module', get_subpackages);
        }


        private static function types_by_package():void
        {
            var r:Vector.<LibType>;
            var m:LibModule = testModule;

            r = LibModule.selectTypesByPackage('', m.types);
            it.expects(r.length).toEqual(1);

            r = LibModule.selectTypesByPackage('test', m.types);
            it.expects(r.length).toEqual(0);

            r = LibModule.selectTypesByPackage('test.pkga', m.types);
            it.expects(r.length).toEqual(7);

            r = LibModule.selectTypesByPackage('test.pkgb.suba', m.types);
            it.expects(r.length).toEqual(2);
        }

        private static function types_by_construct():void
        {
            var r:Vector.<LibType>;
            var m:LibModule = testModule;

            r = LibModule.selectTypesByConstruct(DefinitionConstruct.CLASS, m.types);
            it.expects(r.length).toEqual(8);

            r = LibModule.selectTypesByConstruct(DefinitionConstruct.DELEGATE, m.types);
            it.expects(r.length).toEqual(5);

            r = LibModule.selectTypesByConstruct(DefinitionConstruct.ENUM, m.types);
            it.expects(r.length).toEqual(2);

            r = LibModule.selectTypesByConstruct(DefinitionConstruct.INTERFACE, m.types);
            it.expects(r.length).toEqual(4);

            r = LibModule.selectTypesByConstruct(DefinitionConstruct.STRUCT, m.types);
            it.expects(r.length).toEqual(3);
        }

        private static function get_packages():void
        {
            var r:Vector.<LibType>;
            var m:LibModule = testModule;

            r = LibModule.getPackages(m);
            it.expects(r.length).toEqual(7);
        }

        private static function get_subpackages():void
        {
            var r:Vector.<LibType>;
            var m:LibModule = testModule;

            r = LibModule.getSubpackages('', m);
            it.expects(r.length).toEqual(1);

            r = LibModule.getSubpackages('test', m);
            it.expects(r.length).toEqual(2);

            r = LibModule.getSubpackages('test.pkga', m);
            it.expects(r.length).toEqual(3);
        }


        private static function get testModule():LibModule
        {
            var m:LibModule = new LibModule();

            m.name = 'TestModule';
            m.version = '0.0.0';

            m.addType(getTestType('ClassTopLevel', '', DefinitionConstruct.CLASS));

            m.addType(getTestType('ClassA', 'test.pkga', DefinitionConstruct.CLASS));
            m.addType(getTestType('ClassAa', 'test.pkga.suba', DefinitionConstruct.CLASS));
            m.addType(getTestType('ClassAb', 'test.pkga.subb', DefinitionConstruct.CLASS));
            m.addType(getTestType('ClassAc', 'test.pkga.subc', DefinitionConstruct.CLASS));
            m.addType(getTestType('DelegateA1', 'test.pkga', DefinitionConstruct.DELEGATE));
            m.addType(getTestType('DelegateA2', 'test.pkga', DefinitionConstruct.DELEGATE));
            m.addType(getTestType('EnumA', 'test.pkga', DefinitionConstruct.ENUM));
            m.addType(getTestType('InterfaceA', 'test.pkga', DefinitionConstruct.INTERFACE));
            m.addType(getTestType('InterfaceAa', 'test.pkga.suba', DefinitionConstruct.INTERFACE));
            m.addType(getTestType('StructA1', 'test.pkga', DefinitionConstruct.STRUCT));
            m.addType(getTestType('StructA2', 'test.pkga', DefinitionConstruct.STRUCT));

            m.addType(getTestType('ClassB', 'test.pkgb', DefinitionConstruct.CLASS));
            m.addType(getTestType('ClassBa', 'test.pkgb.suba', DefinitionConstruct.CLASS));
            m.addType(getTestType('ClassBb', 'test.pkgb.subb', DefinitionConstruct.CLASS));
            m.addType(getTestType('DelegateB1', 'test.pkgb', DefinitionConstruct.DELEGATE));
            m.addType(getTestType('DelegateB2', 'test.pkgb', DefinitionConstruct.DELEGATE));
            m.addType(getTestType('DelegateB3', 'test.pkgb', DefinitionConstruct.DELEGATE));
            m.addType(getTestType('EnumB', 'test.pkgb', DefinitionConstruct.ENUM));
            m.addType(getTestType('InterfaceB', 'test.pkgb', DefinitionConstruct.INTERFACE));
            m.addType(getTestType('InterfaceBa', 'test.pkgb.suba', DefinitionConstruct.INTERFACE));
            m.addType(getTestType('StructB', 'test.pkgb', DefinitionConstruct.STRUCT));

            return m;
        }

        private static function getTestType(name:String, packageString:String, construct:DefinitionConstruct):LibType
        {
            var t:LibType = new LibType();

            t.name = name;
            t.interfaceStrings = ['Ia', 'Ib', 'Ic'];
            t.packageString = packageString;
            t.sourceFile = './src/.//' +packageString.split('.').join('/') +'/' +name +'.ls';
            t.construct = construct.toString();

            return t;
        }
    }
}
