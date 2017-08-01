package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.errors.LSDocError;


    public static class lsdocSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('LSDoc');

            it.should('be versioned', be_versioned);
            it.should('return an error when adding a loomlib that does not exist', error_on_no_lib);
            it.should('return an error when adding an invalid loomlib', error_on_bad_lib);
            it.should('add loomlibs idempotently', add_libs_idempotently);
            it.should('find all types in the given loomlibs', find_all_types);
        }


        private static function be_versioned():void
        {
            it.expects(LSDoc.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function error_on_no_lib():void {
            var lsdoc:LSDoc = new LSDoc();
            var e:Vector.<LSDocError>;

            e = lsdoc.addLoomlib('no_such_file.loomlib');
            it.expects(e.length).toEqual(1);
            it.expects(e[0].type).toEqual(LSDocError.FILE_NOT_FOUND);
        }

        private static function error_on_bad_lib():void {
            var lsdoc:LSDoc = new LSDoc();
            var e:Vector.<LSDocError>;

            e = lsdoc.addLoomlib('fixtures/invalid.loomlib');
            it.expects(e.length).toEqual(2);
            it.expects(e[0].type).toEqual(LSDocError.PARSE_FAIL);
            it.expects(e[1].type).toEqual(LSDocError.INVALID_LOOMLIB);
        }

        private static function add_libs_idempotently():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addLoomlib('fixtures/lsdoc.loomlib');
            var numTypes = lsdoc.numTypes;

            lsdoc.addLoomlib('fixtures/lsdoc.loomlib');
            it.expects(lsdoc.numTypes).toEqual(numTypes);
        }

        private static function find_all_types():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addLoomlib('fixtures/lsdoc.loomlib');
            lsdoc.addLoomlib('fixtures/Loom.loomlib');
            it.expects(lsdoc.numTypes).toEqual(313);
        }

    }
}
