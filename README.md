# lsdoc
generate API documentation from doc comments in LoomScript source code

> see lsdoc api documentation documented by lsdoc here: https://ellemenno.github.io/lsdoc/


## Development notes

### starting jekyll
> from the project root

```
bundle exec jekyll serve --watch --source docs/ --destination docs/_site
```

### running the demo
> from the project root

```
export LSDOC=`pwd`
rake clean && rake cli['-p ghpages -o $LSDOC/docs -t $LSDOC/lib/ghpages-template -e $LSDOC/examples -g $LSDOC/guides -l $LSDOC/test/fixtures/lsdoc.loomlib -d']
```
