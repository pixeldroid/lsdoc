---
layout: page
title: Describing code
---


# {{ page.title }}

**lsdoc** follows familiar [JavaDoc][javadoc] and [ASDoc][asdoc] conventions to generate [api documentation](#/api "toggle the API sidebar") from metadata inside documentation comment blocks.
{:.larger.text}

- TOC
{::options toc_levels="2,3" /}
{:toc}


### Documentation comments

Source code is documented in a documentation comment block (`/** ... */`) on the line above the subject:

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
Throughout the generated documentation, main descriptions are rendered where a short form is necessary, and detailed descriptions are rendered where a long form is appropriate.


#### Example code

To include code snippets in documentation comments, use the indented or fenced markdown syntax within the documentation comment:

<pre>
/**
Main description.

Additional description, with code snippet

```as3
var f:Foo = new Foo();
for each(b:Bar in f)
{
   ⇥//...
}
```
*/
</pre>
{:.highlight}

To preserve indentation, use the horizontal tab character (`⇥`). The loomscript compiler strips whitespace when compiling a loomlib, but the lsdoc processor will replace horizontal tab characters with a predefined indent (two spaces, by default; see the [code_indent](code-indent) site template configuration value).
{:.ui.large.warning.message}


### Documentation subjects

The following constructs can be documented in LoomScript:

| construct    | syntax                             |
|--------------|------------------------------------|
| _Types_      | `class`, `interface`, `struct`     |
| _Methods_    | `function`, `delegate`, `operator` |
| _Properties_ | `get`, `set`                       |
| _Fields_     | `var`, `const`                     |


### Tags

Tags in **lsdoc** start with the at sign followed by a key, a space, and value: `@key value`. Tags must always be on their own line.

| tag        | syntax | effect |
|------------|--------|--------|
| copy       | `@copy <source>` | duplicates the description from `source`. Source must be listed as a fully qualified package (`example.ExampleSuperClass`), having an identically named member |
| deprecated | `@deprecated <since-version>` | marks the entry with a deprecated label |
| param      | `@param <description>` | adds a parameter description to the method details table |
| return     | `@return <description>` | adds a _returns_ description row to the method details table |
| see        | `@see <target>` | creates a hyperlink to the specified target url |


Find more details in [Using tags][using-tags].



[asdoc]: http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html "Creating ASDoc comments in ActionScript"
[code-indent]: /guides/Writing-Documentation/Understanding-the-site-template/#template-provided-configuration "Set the indent for documentation code snippets"
[javadoc]: http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html "How to Write Doc Comments for the Javadoc Tool"
[using-tags]: /guides/Writing-Documentation/Using-tags/#/guides/ "How to use tags in lsdoc code comments"
