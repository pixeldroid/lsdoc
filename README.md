# lsdoc
an API docs generator for LoomScript

lsdoc provides an API for loading loomlib libraries and extracting type metadata.

The lsdoc distribution provides a documentation generator and GitHub Pages Jekyll template for creating html documentation that is:
* searchable
* browsable
* cross-linked
* mobile friendly

> see lsdoc api documentation documented by lsdoc here: https://ellemenno.github.io/lsdoc/


![lsdoc screenshot](lsdoc-screenshot.png)

- [installation](#installation)
- [usage](#usage)
- [building](#building)
- [contributing](#contributing)


## installation

> to be written..


## usage

> to be written..



## building

first, install [loomtasks][loomtasks], and [bundler][bundler].

then run `bundle install` to retrieve and install the project dependencies on [Jekyll][jekyll] and the [GitHub Pages gem][ghpages-gem]

### compiling from source and installing for use

    $ rake lib:install
    $ rake template:install

this will build the lsdoc library and install it and the ghpages-template in the currently configured sdk

### running tests

    $ rake test

this will build the lsdoc library, install it in the currently configured sdk, build the test app, and run the test app.

### starting jekyll
> from the project root

    $ bundle exec jekyll serve --watch --source docs/ --destination docs/_site

### running the demo
> from the project root

    $ export LSDOC=`pwd`
    $ export LSDK="$HOME/.loom/sdks/sprint34"
    $ rake clean && rake cli['-p ghpages -o $LSDOC/docs -i $LSDOC/doc/index.md -c $LSDOC/doc/lsdoc.config -e $LSDOC/doc/examples -g $LSDOC/doc/guides -t $LSDK/ghpages-template -l $LSDK/libs/lsdoc.loomlib']


## contributing

Pull requests are welcome!



[bundler]: http://bundler.io "Manage your Ruby application's gem dependencies"
[ghpages-gem]: https://github.com/github/pages-gem "A simple Ruby Gem to bootstrap dependencies for setting up and maintaining a local Jekyll environment in sync with GitHub Pages"
[jekyll]: https://jekyllrb.com/ "Jekyll is a blog-aware, static site generator in Ruby"
[loomtasks]: https://github.com/pixeldroid/loomtasks "Rake tasks for working with loomlibs"
