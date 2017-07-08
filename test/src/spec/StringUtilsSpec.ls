package
{
    import system.platform.Path;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.platform.StringUtils;


    public static class StringUtilsSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('StringUtils');

            it.should('determine that a string starts with a token', starts_with);
            it.should('determine that a string ends with a token', ends_with);
        }


        private static function starts_with():void
        {
            it.expects(StringUtils.startsWith('honeycomb', 'honey')).toBeTruthy();
            it.expects(StringUtils.startsWith('honeycomb', 'honeycomb')).toBeTruthy();
            it.expects(StringUtils.startsWith('honeycomb', 'comb')).toBeFalsey();
            it.expects(StringUtils.startsWith('honey', 'honeycomb')).toBeFalsey();
            it.expects(StringUtils.startsWith('', 'honey')).toBeFalsey();
            it.expects(StringUtils.startsWith(null, 'honey')).toBeFalsey();
            it.expects(StringUtils.startsWith('honeycomb', '')).toBeFalsey();
            it.expects(StringUtils.startsWith('honeycomb', null)).toBeFalsey();
            it.expects(StringUtils.startsWith('', '')).toBeFalsey();
            it.expects(StringUtils.startsWith(null, null)).toBeFalsey();
        }

        private static function ends_with():void
        {
            it.expects(StringUtils.endsWith('sunflower', 'flower')).toBeTruthy();
            it.expects(StringUtils.endsWith('sunflower', 'sunflower')).toBeTruthy();
            it.expects(StringUtils.endsWith('sunflower', 'sun')).toBeFalsey();
            it.expects(StringUtils.endsWith('flower', 'sunflower')).toBeFalsey();
            it.expects(StringUtils.endsWith('', 'flower')).toBeFalsey();
            it.expects(StringUtils.endsWith(null, 'flower')).toBeFalsey();
            it.expects(StringUtils.endsWith('sunflower', '')).toBeFalsey();
            it.expects(StringUtils.endsWith('sunflower', null)).toBeFalsey();
            it.expects(StringUtils.endsWith('', '')).toBeFalsey();
            it.expects(StringUtils.endsWith(null, null)).toBeFalsey();
        }

    }
}
