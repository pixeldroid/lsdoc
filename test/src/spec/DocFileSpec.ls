package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.model.DocFile;
    import pixeldroid.lsdoc.model.DocFileType;


    public static class DocFileSpec
    {
        private static const it:Thing = Spec.describe('DocFile');

        public static function describe():void
        {
            it.should('provide a directory filter', provide_dir_filter);
            it.should('provide a type filter', provide_type_filter);
            it.should('provide a name sort comparator', provide_name_sorter);
            it.should('extract its properties from the given filepath', initialize_from_filepath);
            it.should('serialize to JSON', serialize_to_json);
        }


        private static function provide_dir_filter():void {
            var path:String = 'file.ls';

            var itemA:DocFile = new DocFile('module', 'rootA/' +path, 'rootA');
            var itemB:DocFile = new DocFile('module', 'rootB/' +path, 'rootB');

            var sieve:Function = DocFile.getDirFilter(itemA.root);
            var index:Number = 0;
            var vector:Vector.<Object> = [];

            it.expects(sieve(itemA, index, vector)).toBeTruthy();
            it.expects(sieve(itemB, index, vector)).toBeFalsey();
        }

        private static function provide_type_filter():void {
            var root:String = 'root';

            var itemA:DocFile = new DocFile('module', root +'/file.ls', root);
            var itemB:DocFile = new DocFile('module', root +'/file.md', root);

            var sieve:Function = DocFile.getTypeFilter(DocFileType.CODE);
            var index:Number = 0;
            var vector:Vector.<Object> = [];

            it.expects(sieve(itemA, index, vector)).toBeTruthy();
            it.expects(sieve(itemB, index, vector)).toBeFalsey();
        }

        private static function provide_name_sorter():void {
            var root:String = 'root';

            var v1:Vector.<DocFile> = [
                new DocFile('module', root +'/File.ls', root),
                new DocFile('module', root +'/File.ls', root),
                new DocFile('module', root +'/a/b/File.ls', root),
                new DocFile('module', root +'/a/b/c/File.ls', root),
                new DocFile('module', root +'/a/b/FilePlus.ls', root),
                new DocFile('module', root +'/a/b/c/file.ls', root)
            ];

            it.expects(DocFile.sortByName(v1[2], v1[3])).toEqual(-1);
            it.expects(DocFile.sortByName(v1[0], v1[1])).toEqual( 0);
            it.expects(DocFile.sortByName(v1[5], v1[4])).toEqual( 1);

            var v2:Vector.<DocFile> = v1.slice();
            v2.shuffle();
            v2.sort(DocFile.sortByName);

            for (var i:Number in v2) it.expects(v1[i]).toEqual(v2[i]);
        }

        private static function initialize_from_filepath():void {
            var df:DocFile = new DocFile('module', 'root/a/b/c/File.ls', 'root');

            it.expects(df.name).toEqual('File.ls');
            it.expects(df.path).toEqual('a/b/c/File.ls');
            it.expects(df.root).toEqual('root');
            it.expects(df.type).toEqual(DocFileType.CODE.toString());
        }

        private static function serialize_to_json():void {
            var df:DocFile = new DocFile('module', '/a/b/c/File.ls');
            var js:String = '{"module": "module", "name": "File.ls", "path": "a/b/c/File.ls", "root": "", "type": "CODE"}';

            it.expects(df.toJSON().serialize()).toEqual(js);
        }
    }
}
