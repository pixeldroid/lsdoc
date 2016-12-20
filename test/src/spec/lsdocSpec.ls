package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.LSDoc;
    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;

    public static class lsdocSpec
    {
        private static const fixtureRoot:String = 'fixtures/';

        public static function describe():void
        {
            var it:Thing = Spec.describe('LSDoc');

            it.should('find all loomscript files in the directory tree', function() {
                var lsdoc:LSDoc = new LSDoc();

                lsdoc.addDir(fixtureRoot + 'docs');
                lsdoc.addDir(fixtureRoot + 'src');
                lsdoc.scan();

                it.expects(lsdoc.numFiles).toEqual(7);

                var files:Vector.<DocFile> = lsdoc.files;
                it.expects(files[0].root).toEqual(fixtureRoot + 'docs');
                it.expects(files[0].name).toEqual('markdown-mark.png');
                it.expects(files[0].type).toEqual(DocFileType.MEDIA.toString());
                it.expects(files[6].root).toEqual(fixtureRoot + 'src');
                it.expects(files[6].path).toEqual('com/test/foo/Bar.ls');
                it.expects(files[6].packageName).toEqual('com.test.foo');
            });

            it.should('provide files filtered by directory', function() {
                var lsdoc:LSDoc = new LSDoc();

                lsdoc.addDir(fixtureRoot + 'docs');
                lsdoc.addDir(fixtureRoot + 'src');
                lsdoc.scan();

                var docsFilter:Function = DocFile.getDirFilter(fixtureRoot + 'docs');
                it.expects(lsdoc.filterFiles(docsFilter).length).toEqual(4);

                var srcFilter:Function = DocFile.getDirFilter(fixtureRoot + 'src');
                it.expects(lsdoc.filterFiles(srcFilter).length).toEqual(3);
            });

            it.should('provide files filtered by type', function() {
                var lsdoc:LSDoc = new LSDoc();

                lsdoc.addDir(fixtureRoot + 'docs');
                lsdoc.addDir(fixtureRoot + 'src');
                lsdoc.scan();

                var codeFilter:Function = DocFile.getTypeFilter(DocFileType.CODE);
                it.expects(lsdoc.filterFiles(codeFilter).length).toEqual(3);

                var docFilter:Function = DocFile.getTypeFilter(DocFileType.DOC);
                it.expects(lsdoc.filterFiles(docFilter).length).toEqual(3);

                var mediaFilter:Function = DocFile.getTypeFilter(DocFileType.MEDIA);
                it.expects(lsdoc.filterFiles(mediaFilter).length).toEqual(1);
            });

            it.should('add directories idempotently', function() {
                var lsdoc:LSDoc = new LSDoc();

                lsdoc.addDir(fixtureRoot + 'src');
                lsdoc.addDir(fixtureRoot + 'src');

                it.expects(lsdoc.numDirs).toEqual(1);
            });

            it.should('scan directories idempotently', function() {
                var lsdoc:LSDoc = new LSDoc();

                lsdoc.addDir(fixtureRoot + 'docs');
                lsdoc.addDir(fixtureRoot + 'src');

                lsdoc.scan();
                it.expects(lsdoc.numFiles).toEqual(7);

                lsdoc.scan();
                it.expects(lsdoc.numFiles).toEqual(7);
            });
        }
    }
}
