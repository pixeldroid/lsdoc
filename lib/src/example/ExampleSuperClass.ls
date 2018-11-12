package example
{

    import example.ExampleEnum;
    import example.ExampleInterface;


    /**
    SuperClass description doc comments first line.

    Additional class description documentation comments.

    @see example.ExampleInterface
    */
    public class ExampleSuperClass implements ExampleInterface
    {
        /** Constant field doc comments first line. */
        public static const parent_constant:String = 'A public class constant';

        /** Public field doc comments first line. */
        public var parent_public_field:String = 'A public member field';

        /** Protected field doc comments first line. */
        protected var parent_protected_field:String = 'A protected member field';

        /** Private doc comments should not appear in the API documentation. */
        private var parent_private_field:ExampleEnum = ExampleEnum.ZEROITH;


        /**
        Constructor doc comments first line.
        */
        public function ExampleSuperClass() { }

        /**
        Public property getter doc comments first line.

        @return The literal string phrase 'value'.
        */
        public function get property():String { return 'value'; }

        /** Setter doc comments are ignored; place doc comments on the getter. */
        public function set property(value:String):void { }

        // interface methods should inherit documentation

        /** @copy example.ExampleInterface */
        public function get read_only_property():ExampleEnum { return parent_private_field; }

        /** @copy example.ExampleInterface */
        public function get legacy_property():String { return null; }

        /** @copy example.ExampleInterface */
        public function interface_method(param1:String, ...rest):void { }

        /**
        Public method doc comments first line.

        This method has one required first parameter,
        and an optional second parameter.

        @param param1 The first parameter (required)
        @param param2 The second parameter (optional)
        @return The value of param2 is always returned.
        */
        public function method(param1:String, param2:String = 'parent default'):String { return param2; }

        /**
        Protected method doc comments first line.

        This method has one required first parameter without any documentation,
        and one optional second parameter with documentation.

        @param param2 The second parameter (optional)
        */
        protected function protected_method(param1:String, param2:Number = null):void { }

        /** Private method doc comments should not appear in the API documentation. */
        private function private_method():Boolean { return true; }

    }
}
