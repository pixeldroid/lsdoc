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

    @see example.ExampleSuperClass#constructor
    @see example.ExampleEnum#LAST
    @see #read_only_property
    @see #protected_field
    @see #kitchen_sink_method
    */
    public class ExampleClass extends ExampleSuperClass
    {
        /** Constant field doc comments first and only line. */
        public static const constant:String = 'A public class constant';

        /**
        Public field doc comments first line.

        Second paragraph.

        Third paragraph.
        */
        public var public_field:String = 'A public member field';

        /** Public templated field doc comments first line. */
        public var public_templated_field:Vector.<String> = [];

        /**
        @copy example.ExampleSuperClass#parent_protected_field

        Additional doc comments from another class
        */
        override protected var protected_field:String = 'An overridden protected member field at the subclass level';

        /** Private doc comments should not appear in the API documentation. */
        private var private_field:ExampleEnum = ExampleEnum.LAST;


        /**
        Constructor doc comments first line.

        This constructor takes an optional parameter.
        Not all constructors do. Some take none at all.

        @param constructorParam Initialization info
        */
        public function ExampleClass(constructorParam:String = 'A constructor parameter') { }


        /**
        Public read-only templated property doc comments first line.

        @return A `Dictionary` of `String` keys and `Number` values.
        */
        public function get read_only_templated_property():Dictionary.<String,Number> { return null; }

        /**
        @copy example.ExampleInterface

        Additional doc comments from overriding subclass
        */
        override public function get read_only_property():ExampleEnum { return private_field; }

        /**
        @copy example.ExampleInterface

        Additional doc comments from overriding subclass

        @see example.ExampleSuperClass
        */
        override public function interface_method(param1:String, ...rest):void { }

        /**
        @copy example.ExampleSuperClass

        Additional doc comments from overriding subclass
        */
        override public function get property():String { return 'value'; }

        /** Public property setter doc comments first line (not expected to appear in loomlib or docs). */
        override public function set property(value:String):void { }


        /**
        @copy example.ExampleSuperClass

        Additional doc comments from overriding subclass

        @see example.ExampleSuperClass
        */
        override public function method(param1:String, param2:String = 'child default'):String { return param2; }

        /**
        Templated return value method signature doc comments first line.

        This method signature has a templated return type.

        @return A `Vector` of `String` values.
        */
        public function method_template_return():Vector.<String> { return ['a', 'b']; }

        /**
        Kitchen sink method signature doc comments first line.

        This method signature has 3 template type params and varargs.

        @param param1 A `Vector` of anything
        @param param2 A `Dictionary` using `String` values to look up `Vector`s of anything
        @param param3 A 3D matrix: `m[x][y][z] = 0`
        @param args An optional varargs catchall for any additional params the user wants to supply
        */
        public function kitchen_sink_method(param1:Vector.<Object>, param2:Dictionary.<String,Vector.<Object>>, param3:Vector.<Vector.<Vector.<Number>>>, ...args):void { }

        /**
        @copy example.ExampleSuperClass

        Additional doc comments from overriding subclass

        @see example.ExampleSuperClass
        */
        override protected function protected_method(param1:String, param2:Number = 123):void { }

        /** Private method doc comments should not appear in the API documentation. */
        private function private_method():Boolean { return true; }

    }
}
