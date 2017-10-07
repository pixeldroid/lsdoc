package example
{

    import example.ExampleEnum;

    /**
    Interface description doc comments first line.

    Additional interface description documentation comments.

    @see #interface_method
    */
    public interface ExampleInterface
    {

        /**
        Public read-only property doc comments first line.

        @return An enumeration value
        */
        function get read_only_property():ExampleEnum;

        /**
        Unfashionable old property.

        @return A string value
        @deprecated v2.1.3
        */
        function get legacy_property():String;

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
