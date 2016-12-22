package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;

    public static class DocFileSpec
    {
        public static function describe():void
        {
            var it:Thing = Spec.describe('DocFile');

            it.should('provide a directory filter', function() {
                var path:String = 'file.ls';

                var itemA:DocFile = new DocFile('rootA/' +path, 'rootA');
                var itemB:DocFile = new DocFile('rootB/' +path, 'rootB');

                var sieve:Function = DocFile.getDirFilter(itemA.root);
                var index:Number = 0;
                var vector:Vector.<Object> = [];

                it.expects(sieve(itemA, index, vector)).toBeTruthy();
                it.expects(sieve(itemB, index, vector)).toBeFalsey();
            });

            it.should('provide a type filter', function() {
                var root:String = 'root';

                var itemA:DocFile = new DocFile(root +'/file.ls', root);
                var itemB:DocFile = new DocFile(root +'/file.md', root);

                var sieve:Function = DocFile.getTypeFilter(DocFileType.CODE);
                var index:Number = 0;
                var vector:Vector.<Object> = [];

                it.expects(sieve(itemA, index, vector)).toBeTruthy();
                it.expects(sieve(itemB, index, vector)).toBeFalsey();
            });

            it.should('provide a name sort comparator', function() {
                var root:String = 'root';

                var v1:Vector.<DocFile> = [
                    new DocFile(root +'/File.ls', root),
                    new DocFile(root +'/File.ls', root),
                    new DocFile(root +'/a/b/File.ls', root),
                    new DocFile(root +'/a/b/c/File.ls', root),
                    new DocFile(root +'/a/b/FilePlus.ls', root),
                    new DocFile(root +'/a/b/c/file.ls', root)
                ];

                it.expects(DocFile.sortByName(v1[2], v1[3])).toEqual(-1);
                it.expects(DocFile.sortByName(v1[0], v1[1])).toEqual( 0);
                it.expects(DocFile.sortByName(v1[5], v1[4])).toEqual( 1);

                var v2:Vector.<DocFile> = v1.slice();
                v2.shuffle();
                v2.sort(DocFile.sortByName);

                for (var i:Number in v2) it.expects(v1[i]).toEqual(v2[i]);
            });
        }
    }
}
