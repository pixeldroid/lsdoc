# lsdoc
an API docs generator for LoomScript

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

### compiling from source

    $ rake lib:install

this will build the lsdoc library and install it in the currently configured sdk

### running tests

    $ rake test

this will build the lsdoc library, install it in the currently configured sdk, build the test app, and run the test app.

### starting jekyll
> from the project root

    $ bundle exec jekyll serve --watch --source docs/ --destination docs/_site

### running the demo
> from the project root

    $ export LSDOC=`pwd`
    $ rake clean && rake cli['-p ghpages -o $LSDOC/docs -t $LSDOC/lib/ghpages-template -e $LSDOC/examples -g $LSDOC/guides -l $LSDOC/test/fixtures/lsdoc.loomlib -d']


## contributing

Pull requests are welcome!



[bundler]: http://bundler.io "Manage your Ruby application's gem dependencies"
[ghpages-gem]: https://github.com/github/pages-gem "A simple Ruby Gem to bootstrap dependencies for setting up and maintaining a local Jekyll environment in sync with GitHub Pages"
[jekyll]: https://jekyllrb.com/ "Jekyll is a blog-aware, static site generator in Ruby"
[loomtasks]: https://github.com/pixeldroid/loomtasks "Rake tasks for working with loomlibs"
