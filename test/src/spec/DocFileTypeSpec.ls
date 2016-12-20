package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.model.DocFileType;

    public static class DocFileTypeSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('DocFileType');

            it.should('determine if files are docfiles', function() {
                it.expects(DocFileType.isDocFile('foo.ls')).toBeTruthy();
                it.expects(DocFileType.isDocFile('foo.md')).toBeTruthy();
                it.expects(DocFileType.isDocFile('foo.png')).toBeTruthy();
                it.expects(DocFileType.isDocFile('')).toBeFalsey();
                it.expects(DocFileType.isDocFile('foo.build')).toBeFalsey();
                it.expects(DocFileType.isDocFile('.DS_Store')).toBeFalsey();
            });

            it.should('map files to docfile types', function() {
                it.expects(DocFileType.getDocFileType('foo.ls')).toEqual(DocFileType.CODE);
                it.expects(DocFileType.getDocFileType('foo.md')).toEqual(DocFileType.DOC);
                it.expects(DocFileType.getDocFileType('foo.png')).toEqual(DocFileType.MEDIA);
                it.expects(DocFileType.getDocFileType('')).toEqual(DocFileType.UNKNOWN);
                it.expects(DocFileType.getDocFileType('foo.build')).toEqual(DocFileType.UNKNOWN);
                it.expects(DocFileType.getDocFileType('.DS_Store')).toEqual(DocFileType.UNKNOWN);
            });
        }
    }
}
