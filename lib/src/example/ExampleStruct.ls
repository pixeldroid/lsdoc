package example
{

    /**
    Struct description doc comments first line.

    Additional struct description documentation comments.
    */
    public struct ExampleStruct
    {

        /** Public field doc comments first line. */
        public var x:Number;

        /** Public field doc comments first line. */
        public var y:Number;


        /**
        Constructor doc comments first line.

        This constructor takes two optional parameters.
        Not all constructors do. Some take none at all.

        @param x Value for the x component
        @param y Value for the y component
        */
        public function ExampleStruct(x:Number = 1, y:Number = 2) {
            this.x = x;
            this.y = y;
        }

        /**
        Public static operator doc comments first line.

        The assignment operator transfers the value of `b` to `a`, and returns `a`.
        */
        public static operator function =(a:ExampleStruct, b:ExampleStruct):ExampleStruct
        {
            a.x = b.x;
            a.y = b.y;

            return a;
        }

        /**
        Public static operator doc comments first line.

        The addition operator combines the values of `b` and `a` into a new instance.
        */
        public static operator function +(a:ExampleStruct, b:ExampleStruct):ExampleStruct
        {
            return new ExampleStruct(a.x + b.x, a.y + b.y);
        }

        /**
        Public static operator doc comments first line.

        The addition with assignment operator combines the values of `b` into the calling instance.
        */
        public operator function +=(b:ExampleStruct)
        {
            x += b.x;
            y += b.y;
        }
    }

}
