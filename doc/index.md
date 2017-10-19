---
layout: page
title: Home
this: "**lsdoc**"
---

# {{ page.title }}

{{ page.this }} generates clean technical documentation from [LoomScript][loomscript] code comments, examples, and guides.
{:.ui.large.message}

## Code comments

{{ page.this }} follows familiar [JavaDoc][javadoc] and [ASDoc][asdoc] conventions.

Write documentation in [Markdown][markdown], in a doc comment block (`/** ... */`) on the line above the subject:

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
Main descriptions are rendered where a shorter form is desired, and detailed descriptions are rendered where a long form is appropriate.

Tags in {{ page.this }} start with the at sign followed by a key, a space, and value: `@key value`. Tags must always be on their own line.


The following subjects can be documented in LoomScript:

### Doc comment subjects

- _Types_: `class`, `interface`, `struct`
- _Methods_: `function`, `delegate`, `operator`
- _Properties_: `get`, `set`
- _Fields_: `var`, `const`

The following tags are supported by {{ page.this }}:

### @tags

- [`@copy <source>`][tag-copy]
- [`@deprecated <since-version>`][tag-deprecated]
- [`@param <description>`][tag-param]
- [`@return <description>`][tag-return]
- [`@see <target>`][tag-see]


## Examples

> to be written..


## Guides

> to be written..

```
[tag-copy]:
[tag-deprecated]:
[tag-param]:
[tag-return]:
[tag-see]:
```

[asdoc]: http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html "Creating ASDoc comments in ActionScript"
[javadoc]: http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html "How to Write Doc Comments for the Javadoc Tool"
[loomscript]: https://github.com/LoomSDK/LoomSDK "The Loom SDK, a native mobile app and game framework"
[markdown]: https://guides.github.com/features/mastering-markdown/ "Markdown is a lightweight markup language with plain text formatting syntax"
