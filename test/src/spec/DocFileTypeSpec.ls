package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.model.DocFileType;


    public static class DocFileTypeSpec
    {
        private static const it:Thing = Spec.describe('DocFileType');

        public static function describe():void
        {
            it.should('map code files to the CODE type', detect_code_files);
            it.should('map documentation files to the DOC type', detect_doc_files);
            it.should('map media files to the MEDIA type', detect_media_files);
            it.should('map unsupported files to the UNKNOWN type', detect_unknown_files);
            it.should('determine if files are docfiles', determine_docfiles);
        }


        private static function detect_code_files():void
        {
            it.expects(DocFileType.getDocFileType('foo.ls')).toEqual(DocFileType.CODE);
        }

        private static function detect_doc_files():void
        {
            it.expects(DocFileType.getDocFileType('foo.md')).toEqual(DocFileType.DOC);
        }

        private static function detect_media_files():void
        {
            it.expects(DocFileType.getDocFileType('foo.gif')).toEqual(DocFileType.MEDIA);
            it.expects(DocFileType.getDocFileType('foo.jpg')).toEqual(DocFileType.MEDIA);
            it.expects(DocFileType.getDocFileType('foo.png')).toEqual(DocFileType.MEDIA);
        }

        private static function detect_unknown_files():void
        {
            it.expects(DocFileType.getDocFileType('')).toEqual(DocFileType.UNKNOWN);
            it.expects(DocFileType.getDocFileType('foo.build')).toEqual(DocFileType.UNKNOWN);
            it.expects(DocFileType.getDocFileType('.DS_Store')).toEqual(DocFileType.UNKNOWN);
        }

        private static function determine_docfiles():void
        {
            it.expects(DocFileType.isDocFile('foo.ls')).toBeTruthy();
            it.expects(DocFileType.isDocFile('foo.md')).toBeTruthy();
            it.expects(DocFileType.isDocFile('foo.png')).toBeTruthy();

            it.expects(DocFileType.isDocFile('')).toBeFalsey();
            it.expects(DocFileType.isDocFile('foo.build')).toBeFalsey();
            it.expects(DocFileType.isDocFile('.DS_Store')).toBeFalsey();
        }
    }
}
