package com.test.foo
{
    public class Bar
    {
        public static const version:String = '1.0.0';

        public function Bar()
        {
            method();
        }

        public function method(param1:Number=0):String {
            return param1.toString();
        }
    }
}
