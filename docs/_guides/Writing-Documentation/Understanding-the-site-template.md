---
layout: page
title: Understanding the site template
---

# {{ page.title }}

> lsdoc, via the [GitHub Pages processor][ghpages-processor], prepares files for [GitHub Pages][ghpages] to render (which uses [Jekyll][ghjekyll] as its static site render engine).
> <br><br>
> The GitHub Pages processor leverages a [site template][ghpages-template] to provide the css, javascript, and Jekyll layouts necessary to render its generated documentation.
{:.larger.text}

This guide describes the folder structure, layouts, and includes of the template used by the GitHub Pages processor to prepare api documentation for rendering by Jekyll.
{:.larger.text}

- TOC
{::options toc_levels="2,3" /}
{:toc}


## Overview

The ghpages template comprises the following main pieces, discussed in detail in the sections below:

    ├─_api/             generated documentation built by lsdoc
    ├─_config.yml       generated Jekyll configuration built by lsdoc
    ├─_examples/        / user provided content /
    ├─_guides/          / user provided content /
    ├─_includes/        liquid partials
    │ ├─elements/       html partials used in layouts
    │ ├─scripts/        js partials and libraries used in layouts
    │ ├─styles/         css used in layouts
    │ │ ├─semantic-ui/  css framework files
    │ └─themes/         css theme files
    ├─_layouts/         jekyll page layouts
    ├─ghpages.config    template settings for Jekyll config
    ├─index.md          / user provided content /
    ├─scripts/          javascript aggregation into single file
    └─styles/           css aggregation into single file


## API Documentation

As lsdoc processes loomlibs to generate API documentation, the results are stored in the `_api` directory.
These are auto-generated html and markdown files for all of the packages and types defined in the loomlib.
To change the content of these files, don't edit them directly. Instead, add or edit existing documentation comments in the source code.

For examples of the supported markdown features, see the [markdown sampler][markdown-sampler] and the the [documentation examples][documentation-examples].
To understand the documentation process, see [Creating guides and examples][creating-guides-and-examples] and [Describing code][describing-code]
To examine the implementation, see [GHPagesProcessor.ls][GHPagesProcessor.ls].

lsdoc will auto-link package namespaces to packages and types it can resolve, i.e. those that are found within the loomlib.
Documentation for types not defined in the loomlib is not generated (it should be provided by the project of the defining loomlib).


## Jekyll configuration

Jekyll expects to find global site configuration values in `_config.yml`.
In the template this is a placeholder file that lsdoc overwrites in the course of generating documentation by merging the following configuration files:

- `doc/lsdoc.config` &mdash; for user-provided values
- `ghpages-template/ghpages.config` &mdash; for template-provided values

### User provided configuration

The user should provide the following project metadata values in `doc/lsdoc.config`:

- `project.name` : _used in footer attribution_ &mdash; Name of the project being documented
- `project.owner` : _used in footer attribution_ &mdash; Copyright author
- `project.repo` : _used in footer attribution_ &mdash; Link to the project source code repo
- `project.version` : _used in title_ &mdash; Project version

### Template provided configuration

The template defines the following configuration values in `ghpages-template/ghpages.config`:

- `code_indent` : _used by the site template_ &mdash; Number of spaces to use when indenting lines of code in doc comments
- `collections` : _used by Jekyll_ &mdash; [Collection][jekyll-collection] folders to expect api docs, examples, and guides to live in
- `compress_html` : _used by the site template_ &mdash; Settings for stripping comments and whitespace from generated html, used in the `compress.html` layout
- `example_root` : _used by the site template_ &mdash; Site variable used in layouts to reference the examples path value
- `guide_root` : _used by the site template_ &mdash; Site variable used in layouts to reference the guides path value
- `highlighter` : _used by Jekyll_ &mdash; Specifies the [code hilighting engine used by GitHub Pages][ghpages-rouge] (Rouge), so local execution matches remote
- `module_root` : _used by the site template_ &mdash; Site variable used in layouts to reference the api docs path value
- `permalink` : _used by Jekyll_ &mdash; Specifies the 'pretty' permalink style (see [Built-in permalink styles][jekyll-permalink])
- `plugins` : _used by Jekyll_ &mdash; Requests enablement of the [jemoji plugin][ghpages-jemoji]
- `sass` : _used by Jekyll_ &mdash; Specifies compressed css when processed by the [scssify filter][jekyll-scssify]
- `template_version` : _used by the site template_ &mdash; Declares the current template version



## Examples

> tbd


## Guides

> tbd


## Includes

> tbd


## Layouts

![layouts](jekyll-layouts.png "Jekyll layouts diagram")


## Homepage

The first page seen by a visitor to the site is defined by the contents of `index.md`.

This file must start with a [YAML front-matter declaration][front-matter], which may be empty. After that, content is up to the user.
Typically, a front-matter declaration will include at least the following:

```yaml
---
layout: page
title: My project
---
```


## Scripts

> tbd


## Styles

> tbd




[creating-guides-and-examples]: /guides/Writing-Documentation/Creating-guides-and-examples/#/guides/ "lsdoc guides: Creating guides and examples"
[describing-code]: /guides/Writing-Documentation/Describing-code/#/guides/ "lsdoc guides: Describing code"
[documentation-examples]: /examples/documenting/#/examples/ "Examples of documentation pages generated from source code doc comments"
[front-matter]: https://jekyllrb.com/docs/frontmatter/ "YAML front matter is at minimum a set of triple-dashed lines"
[ghjekyll]: https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/ "Using Jekyll as a static site generator with GitHub Pages"
[ghpages-jemoji]: https://help.github.com/articles/emoji-on-github-pages/ "Emoji on GitHub Pages"
[ghpages-processor]: /api/pixeldroid/lsdoc/processors/GHPagesProcessor/#/api/ "API documentation for GHPagesProcessor"
[ghpages-rouge]: https://help.github.com/articles/using-syntax-highlighting-on-github-pages/ "Using syntax highlighting on GitHub Pages"
[ghpages-template]: https://github.com/pixeldroid/lsdoc/tree/master/lib/ghpages-template "site template files for rendering code docs with lsdoc for hosting on GitHub Pages"
[ghpages]: https://pages.github.com/ "GitHub Pages"
[GHPagesProcessor.ls]: https://github.com/ellemenno/lsdoc/blob/master/lib/src/pixeldroid/lsdoc/processors/GHPagesProcessor.ls "lsdoc source code: GHPagesProcessor.ls"
[jekyll-collection]: https://jekyllrb.com/docs/collections/#step1 "Tell Jekyll to read in your collection"
[jekyll-permalink]: https://jekyllrb.com/docs/permalinks/#builtinpermalinkstyles "Built-in permalink styles"
[jekyll-scssify]: https://jekyllrb.com/docs/templates/#filters "Jekyll sassify filter"
[lsdoc]: https://github.com/pixeldroid/lsdoc "generate API documentation from doc comments in LoomScript source code"
[markdown-sampler]: /examples/sampler/#/examples/ "Samples of the markdown supported by lsdoc and GitHub Pages"

