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

        @param a The instance to update
        @param b The instance to read from
        @return The first parameter is returned after being updated with the values of the second.
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

        @param a The left-hand operand
        @param b The right-hand operand
        @return A new instance is returned, created from the sums of the x and y components of the operands.

        @see #+=
        */
        public static operator function +(a:ExampleStruct, b:ExampleStruct):ExampleStruct
        {
            return new ExampleStruct(a.x + b.x, a.y + b.y);
        }

        /**
        Public operator doc comments first line.

        The addition with assignment operator combines the values of `b` into this instance.

        @param b The right-hand operand to be added to this instance

        @see #+
        */
        public operator function +=(b:ExampleStruct):void
        {
            x += b.x;
            y += b.y;
        }
    }

}
