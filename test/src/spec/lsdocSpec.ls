package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.error.LSDocError;
    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;


    public static class lsdocSpec
    {
        private static const it:Thing = Spec.describe('LSDoc');

        public static function describe():void
        {
            it.should('be versioned', be_versioned);
            it.should('return an error when no directories have been added for scanning', error_on_no_dir);
            it.should('return an error when a directory does not exist', error_on_missing_dir);
            it.should('find all docfiles in the directory tree', find_files);
            it.should('provide files filtered by directory', filter_by_dir);
            it.should('provide files filtered by type', filter_by_type);
            it.should('add directories idempotently', add_idempotently);
            it.should('scan directories idempotently', scan_idempotently);
        }


        private static const fixtureRoot:String = 'fixtures/';
        private static const module:String = 'test';

        private static function be_versioned():void
        {
            it.expects(LSDoc.version).toPatternMatch('(%d+).(%d+).(%d+)', 3);
        }

        private static function error_on_no_dir():void {
            var lsdoc:LSDoc = new LSDoc();
            var e:Vector.<LSDocError>;

            e = lsdoc.scan();
            it.expects(e.length).toEqual(1);
            it.expects(e[0].type).toEqual(LSDocError.FILE_NOT_FOUND);
        }

        private static function error_on_missing_dir():void {
            var lsdoc:LSDoc = new LSDoc();
            var e:Vector.<LSDocError>;

            e = lsdoc.addDir(fixtureRoot + 'src', module);
            it.expects(e.length).toEqual(0);

            e = lsdoc.addDir(fixtureRoot + 'floober', module);
            it.expects(e.length).toEqual(1);
            it.expects(e[0].type).toEqual(LSDocError.DIR_NOT_FOUND);
        }

        private static function find_files():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'docs', module);
            lsdoc.addDir(fixtureRoot + 'src', module);
            lsdoc.scan();

            it.expects(lsdoc.numFiles).toEqual(7);

            var files:Vector.<DocFile> = lsdoc.files;
            it.expects(files).not.toBeEmpty();
            it.expects(files[0].root).toEqual(fixtureRoot + 'docs');
            it.expects(files[0].name).toEqual('markdown-mark.png');
            it.expects(files[0].type).toEqual(DocFileType.MEDIA.toString());
            it.expects(files[6].root).toEqual(fixtureRoot + 'src');
            it.expects(files[6].path).toEqual('com/test/foo/Bar.ls');
            it.expects(files[6].module).toEqual('test');
        }

        private static function filter_by_dir():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'docs', module);
            lsdoc.addDir(fixtureRoot + 'src', module);
            lsdoc.scan();

            var docsFilter:Function = DocFile.getDirFilter(fixtureRoot + 'docs');
            it.expects(lsdoc.filterFiles(docsFilter).length).toEqual(4);

            var srcFilter:Function = DocFile.getDirFilter(fixtureRoot + 'src');
            it.expects(lsdoc.filterFiles(srcFilter).length).toEqual(3);
        }

        private static function filter_by_type():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'docs', module);
            lsdoc.addDir(fixtureRoot + 'src', module);
            lsdoc.scan();

            var codeFilter:Function = DocFile.getTypeFilter(DocFileType.CODE);
            it.expects(lsdoc.filterFiles(codeFilter).length).toEqual(3);

            var docFilter:Function = DocFile.getTypeFilter(DocFileType.DOC);
            it.expects(lsdoc.filterFiles(docFilter).length).toEqual(3);

            var mediaFilter:Function = DocFile.getTypeFilter(DocFileType.MEDIA);
            it.expects(lsdoc.filterFiles(mediaFilter).length).toEqual(1);
        }

        private static function add_idempotently():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'src', module);
            lsdoc.addDir(fixtureRoot + 'src', module);

            it.expects(lsdoc.numDirs).toEqual(1);
        }

        private static function scan_idempotently():void {
            var lsdoc:LSDoc = new LSDoc();

            lsdoc.addDir(fixtureRoot + 'docs', module);
            lsdoc.addDir(fixtureRoot + 'src', module);

            lsdoc.scan();
            it.expects(lsdoc.numFiles).toEqual(7);

            lsdoc.scan();
            it.expects(lsdoc.numFiles).toEqual(7);
        }
    }
}
