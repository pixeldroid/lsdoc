package
{
    import system.platform.Path;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.json.Json;
    import pixeldroid.task.TaskVersion;
    import pixeldroid.util.Log;


    public static class DependenciesSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('library dependencies');

            it.should('have the correct versions of dependent libraries', have_right_libs);
        }


        private static function have_right_libs():void
        {
            it.expects(Json.version).toEqual('1.0.0');
            it.expects(TaskVersion.version).toEqual('0.0.1');
            it.expects(Log.version).toEqual('2.0.0');
        }

    }
}
