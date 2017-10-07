package example
{
    /**
    Enum doc comments first line.

    This enumeration starts at zero and counts by ones,
    and has a `LAST` entry with value `999`.

    The individual values can have their own doc comments.
    */
    public enum ExampleEnum
    {
        ZEROITH = 0,

        /** `FIRST` value doc comments, first line. */
        FIRST,

        SECOND,

        THIRD,

        /** The numerical value of `LAST` is `999`. */
        LAST = 999
    }
}
