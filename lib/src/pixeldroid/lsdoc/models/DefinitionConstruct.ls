package pixeldroid.lsdoc.models
{

    /**
    An enumeration of Loom types.

    Unlike an Enum type, the values of this class are convertible to strings.
    */
    public class DefinitionConstruct
    {
        public static const CLASS:DefinitionConstruct = new DefinitionConstruct('CLASS');
        public static const DELEGATE:DefinitionConstruct = new DefinitionConstruct('DELEGATE');
        public static const ENUM:DefinitionConstruct = new DefinitionConstruct('ENUM');
        public static const INTERFACE:DefinitionConstruct = new DefinitionConstruct('INTERFACE');
        public static const STRUCT:DefinitionConstruct = new DefinitionConstruct('STRUCT');

        public static function fromString(construct:String):DefinitionConstruct
        {
            switch(construct)
            {
                case CLASS.name: return CLASS;
                case DELEGATE.name: return DELEGATE;
                case ENUM.name: return ENUM;
                case INTERFACE.name: return INTERFACE;
                case STRUCT.name: return STRUCT;
            }

            return null;
        }


        private var _name:String;

        public function DefinitionConstruct(constructName:String)
        {
            _name = constructName;
        }


        public function get name():String { return _name; }

        public function toString():String { return _name; }
    }
}
