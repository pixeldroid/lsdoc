package example
{

    import example.ExampleEnum;

    /**
    Interface description doc comments first line.

    Additional interface description documentation comments.
    */
    public interface ExampleInterface
    {

        /** Public read-only property doc comments first line. */
        function get read_only_property():ExampleEnum;

        /**
        Public interface method doc comments first line.

        This method has one required first parameter,
        and can accept any number of additional params via the rest arg (`...`).

        @param param1 The first parameter (required)
        @param rest Any additional params (optional)
        */
        function interface_method(param1:String, ...rest):void;

    }
}
