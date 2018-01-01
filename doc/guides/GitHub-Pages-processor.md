---
layout: page
title: GitHub Pages processor
---

> this page's content needs to be re-homed and this guide deleted

# {{ page.title }}

The {{ page.title }} for **lsdoc** follows familiar [JavaDoc][javadoc] and [ASDoc][asdoc] conventions to generate [api documentation](#/api "toggle the API sidebar"), [examples](#/examples "toggle the Examples sidebar"), and [guides](#/guides "toggle the Guides sidebar").


- TOC
{::options toc_levels="2,3" /}
{:toc}


## Usage

* Write documentation in [Markdown][markdown-syntax] (specifically, [kramdown][kramdown-syntax]), inside [code comments](#Code-comments "jump to the code comments section"), or in stand-alone text files.
* Run **lsdoc** with the `ghpages` processor to generate ready-to-publish documentation in an output folder (see the [Running lsdoc guide][run-lsdoc] for more details).
* Configure your GitHub repo to render the output folder as your project documentation site (see [Configuring a publishing source for GitHub Pages][ghpages-howto] for more details).


### Code comments

Code is documented in a documentation comment block (`/** ... */`) on the line above the subject:

```as3
/**
Main description.

Additional description.

@param baz parameter description
@return Return value description
*/
public function bar(baz:String):Vector.<Bat> {}
```

The first line in a doc comment forms the main description. Additional descriptive lines fill out the detailed description.
Main descriptions are rendered where a short form is necessary, and detailed descriptions are rendered where a long form is appropriate.


### Documentation subjects

The following constructs can be documented in LoomScript:

| construct    | syntax                             |
|--------------|------------------------------------|
| _Types_      | `class`, `interface`, `struct`     |
| _Methods_    | `function`, `delegate`, `operator` |
| _Properties_ | `get`, `set`                       |
| _Fields_     | `var`, `const`                     |


### Tags

Tags in {{ page.this }} start with the at sign followed by a key, a space, and value: `@key value`. Tags must always be on their own line.

| tag        | syntax | effect |
|------------|--------|--------|
| copy       | `@copy <source>` | duplicates the description from `source`. Source must be listed as a fully qualified package (`example.ExampleSuperClass`), having an identically named member |
| deprecated | `@deprecated <since-version>` | marks the entry with a deprecated label |
| param      | `@param <description>` | adds a parameter description to the method details table |
| return     | `@return <description>` | adds a _returns_ description row to the method details table |
| see        | `@see <target>` | creates a hyperlink to the specified target url |


## Implementation

Find the [GHPagesProcessor][ghpages-processor-api] implementation under `pixeldroid.lsdoc.processors.GHPagesProcessor`.

The [GitHub Pages template guide][ghpages-template] describes the structure and function of the site template used by the `ghpages` processor.



[asdoc]: http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html "Creating ASDoc comments in ActionScript"
[ghpages-howto]: https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/ "Configuring a publishing source for GitHub Pages"
[ghpages-processor-api]: /api/pixeldroid/lsdoc/processors/GHPagesProcessor/#/api/ "API documentation for GHPagesProcessor"
[ghpages-template]: /guides/GitHub-Pages-template/#/guides/ "GitHub Pages template guide"
[javadoc]: http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html "How to Write Doc Comments for the Javadoc Tool"
[kramdown-syntax]: https://kramdown.gettalong.org/syntax.html "kramdown syntax documentation"
[markdown-syntax]: https://guides.github.com/features/mastering-markdown/ "Markdown is a lightweight markup language with plain text formatting syntax"
[run-lsdoc]: /guides/Running-lsdoc/#/guides/ "Running lsdoc guide"
