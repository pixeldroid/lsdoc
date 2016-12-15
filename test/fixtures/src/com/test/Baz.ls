package com.test
{
    public class Baz
    {
        public var s:String = 'baz';

        public function Baz()
        {
            method();
        }

        public function method(param1:Number=0):String {
            return param1.toString();
        }
    }
}
