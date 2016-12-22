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

            it.should('map code files to the CODE type', function() {
                it.expects(DocFileType.getDocFileType('foo.ls')).toEqual(DocFileType.CODE);
            });

            it.should('map documentation files to the DOC type', function() {
                it.expects(DocFileType.getDocFileType('foo.md')).toEqual(DocFileType.DOC);
            });

            it.should('map media files to the MEDIA type', function() {
                it.expects(DocFileType.getDocFileType('foo.gif')).toEqual(DocFileType.MEDIA);
                it.expects(DocFileType.getDocFileType('foo.jpg')).toEqual(DocFileType.MEDIA);
                it.expects(DocFileType.getDocFileType('foo.png')).toEqual(DocFileType.MEDIA);
            });

            it.should('map unsupported files to the UNKNOWN type', function() {
                it.expects(DocFileType.getDocFileType('')).toEqual(DocFileType.UNKNOWN);
                it.expects(DocFileType.getDocFileType('foo.build')).toEqual(DocFileType.UNKNOWN);
                it.expects(DocFileType.getDocFileType('.DS_Store')).toEqual(DocFileType.UNKNOWN);
            });

            it.should('determine if files are docfiles', function() {
                it.expects(DocFileType.isDocFile('foo.ls')).toBeTruthy();
                it.expects(DocFileType.isDocFile('foo.md')).toBeTruthy();
                it.expects(DocFileType.isDocFile('foo.png')).toBeTruthy();

                it.expects(DocFileType.isDocFile('')).toBeFalsey();
                it.expects(DocFileType.isDocFile('foo.build')).toBeFalsey();
                it.expects(DocFileType.isDocFile('.DS_Store')).toBeFalsey();
            });
        }
    }
}
