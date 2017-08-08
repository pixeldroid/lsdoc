package example
{

    import example.ExampleEnum;
    import example.ExampleInterface;


    /**
    SuperClass description doc comments first line.

    Additional class description documentation comments.
    */
    public class ExampleSuperClass implements ExampleInterface
    {
        /** Constant field doc comments first line. */
        public static const constant:String = 'A public class constant';

        /** Public field doc comments first line. */
        public var parent_public_var:String = 'A public member variable';

        /** Protected field doc comments first line. */
        protected var parent_protected_var:String = 'A protected member variable';

        /** Private field doc comments should not appear in the API documentation. */
        private var parent_private_var:ExampleEnum = ExampleEnum.ZEROITH;


        /**
        Constructor doc comments first line.
        */
        public function ExampleSuperClass() { }

        /** Public property getter doc comments first line. */
        public function get property():String { return 'value'; }

        /** Public property setter doc comments first line. */
        public function set property(value:String):void { }

        // interface methods

        /** @inherit */
        public function get read_only_property():ExampleEnum { return parent_private_var; }

        /** @inherit */
        public function interface_method(param1:String, ...rest):void { }

        /**
        Public method doc comments first line.

        This method has one required first parameter,
        and an optional second parameter.

        @param param1 The first parameter (required)
        @param param2 The second parameter (optional)
        */
        public function method(param1:String, param2:String = 'parent default'):String { return param2; }

        /**
        Protected method doc comments first line.

        This method has one required first parameter,
        and one optional second parameter.

        @param param1 The first parameter (required)
        @param param2 The second parameter (optional)
        */
        protected function protected_method(param1:String, param2:Number = 123):void { }

        /** Private method doc comments should not appear in the API documentation. */
        private function private_method():Boolean { return true; }

    }
}
