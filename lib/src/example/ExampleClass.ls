package example
{

    import example.ExampleEnum;
    import example.ExampleSuperClass;


    /**
    Class description doc comments first line.

    Additional class description documentation comments.

    Code sample:
    ```as3
    var c:ExampleClass = new ExampleClass();
    ```

    @see example.ExampleSuperClass
    */
    public class ExampleClass extends ExampleSuperClass
    {
        /** Constant field doc comments first line. */
        public static const constant:String = 'A public class constant';

        /** Public field doc comments first line. */
        public var public_var:String = 'A public member variable';

        /** Protected field doc comments first line. */
        protected var protected_var:String = 'A protected member variable';

        /** Private field doc comments should not appear in the API documentation. */
        private var private_var:ExampleEnum = ExampleEnum.LAST;


        /**
        Constructor doc comments first line.

        This constructor takes an optional parameter.
        Not all constructors do. Some take none at all.

        @param constructorParam Initialization info
        */
        public function ExampleClass(constructorParam:String = 'A constructor parameter') { }

        /** Public read-only property doc comments first line. */
        override public function get read_only_property():ExampleEnum { return private_var; }

        /** Public property getter doc comments first line. */
        override public function get property():String { return 'value'; }

        /** Public property setter doc comments first line. */
        override public function set property(value:String):void { }

        /**
        Overridden interface method doc comments first line.

        This method has one required first parameter,
        and can accept any number of additional params via the rest arg (`...`).

        @param param1 The first parameter (required)
        @param rest Any additional params (optional)
        */
        override public function interface_method(param1:String, ...rest):void { }

        /**
        Overridden public doc comments first line.

        This method has one required first parameter,
        and an optional second parameter.

        The second parameter's defaul value is different than that of the base class.

        @param param1 The first parameter (required)
        @param param2 The second parameter (optional)
        */
        public function method(param1:String, param2:String = 'child default'):String { return param2; }

        /**
        Overridden protected method doc comments first line.

        This method has one required first parameter,
        and one optional second parameter.

        @param param1 The first parameter (required)
        @param param2 The second parameter (optional)
        */
        override protected function protected_method(param1:String, param2:Number = 123):void { }

        /** Private method doc comments should not appear in the API documentation. */
        private function private_method():Boolean { return true; }

    }
}
