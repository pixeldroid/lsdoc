package pixeldroid.lsdoc.models
{

    public class DefinitionConstruct
    {
        public static const CLASS:DefinitionConstruct = new DefinitionConstruct('CLASS');
        public static const DELEGATE:DefinitionConstruct = new DefinitionConstruct('DELEGATE');
        public static const ENUM:DefinitionConstruct = new DefinitionConstruct('ENUM');
        public static const INTERFACE:DefinitionConstruct = new DefinitionConstruct('INTERFACE');
        public static const STRUCT:DefinitionConstruct = new DefinitionConstruct('STRUCT');


        private var _name:String;

        public function DefinitionConstruct(constructName:String)
        {
            _name = constructName;
        }


        public function get name():String { return _name; }

        public function toString():String { return _name; }
    }
}
