package example
{
    /**
    Delegate method doc comments first line.

    This method has one required parameter.

    @param param1 The first parameter
    */
    public delegate ExampleDelegate(param1:String):void;

    /**
    Another delegate's method doc comments first line.

    This method has three required parameters.

    @param param1 The first parameter
    @param param2 The second parameter
    @param param3 The third parameter
    */
    public delegate OtherExampleDelegate(param1:String, param2:Vector.<Object>, param3:Dictionary.<String,Vector.<Object>>):void;
}
