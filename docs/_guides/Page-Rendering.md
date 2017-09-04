---
layout: page
title: Page Rendering
---

# {{ page.title }}

[lsdoc][lsdoc] prepares files for [GitHub Pages][ghpages] to render, using [Jekyll][ghjekyll] as its static site render engine.

The implementation of this pre-processing phase is contained in [`lib/ghpages-template/`][ghpages-template].

This guide describes the folder structure, layouts, and includes used by lsdoc to prepare api documentation for rendering by Jekyll.

The ghpages template comprises the following main pieces, discussed in detail in the sections below:

```
├─index.md          / user provided content        /
├─_config.yml       / GitHub pages / Jekyll config /
├─_api/             generated documentation built by lsdoc
├─_examples/        / user provided content        /
├─_guides/          / user provided content        /
├─_includes/        liquid partials
│ ├─elements/       html partials used in layouts
│ ├─scripts/        js partials and libraries used in layouts
│ ├─styles/         css used in layouts
│ │ ├─semantic-ui/  css framework files
│ └─themes/         css theme files
├─_layouts/         jekyll page layouts
├─scripts/          javascript aggregation into single file
└─styles/           css aggregation into single file
```

- [Homepage](#Homepage)
- [Site configuration](#Site-configuration)
- [API Documentation](#API-Documentation)
- [Examples](#Examples)
- [Guides](#Guides)
- [Includes](#Includes)
- [Layouts](#Layouts)
- [Scripts](#Scripts)
- [Styles](#Styles)


## Homepage

The first page seen by a visitor to the site is defined by the contents of `index.md`.

This file must start with a [YAML front-matter declaration][front-matter], which may be empty. After that, content is up to the user.


## Site configuration

Global site configuration values are defined in `_config.yml`.

There are also a few values that should be updated per project by the user:

### Project-specific values

 - `code_indent` - Number of spaces to use when indenting lines of code in doc comments
 - `project.name` - Name of the project being documented (used in footer attribution)
 - `project.repo` - Link to the project source code repo (used in footer attribution)
 - `project.owner` - Copyright author (used in footer attribution)
 - `project.version` - Project version (used in title)


## API Documentation

> tbd


## Examples

> tbd


## Guides

> tbd


## Includes

> tbd


## Layouts

![layouts][jekyll-layouts]


## Scripts

> tbd


## Styles

> tbd



[front-matter]: https://jekyllrb.com/docs/frontmatter/ "YAML front matter is at minimum a set of triple-dashed lines"
[ghjekyll]: https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/ "Using Jekyll as a static site generator with GitHub Pages"
[ghpages]: https://pages.github.com/ "GitHub Pages"
[ghpages-template]: https://github.com/pixeldroid/lsdoc/tree/master/lib/ghpages-template "lsdoc template files for rendering code docs with GitHub Pages"
[jekyll-layouts]: jekyll-layouts.png "Jekyll layouts diagram"
[lsdoc]: https://github.com/pixeldroid/lsdoc "generate API documentation from doc comments in LoomScript source code"
