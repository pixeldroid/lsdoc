package pixeldroid.lsdoc.processors
{
    import pixeldroid.lsdoc.processors.ProcessingContext;
    import pixeldroid.task.TaskGroup;

    public interface LSDocProcessor extends TaskGroup
    {
        function initialize(context:ProcessingContext):void;
        function get context():ProcessingContext;
    }
}
