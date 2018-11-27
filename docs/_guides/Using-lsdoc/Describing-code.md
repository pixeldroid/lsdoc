---
layout: page
title: Describing code

order: 1
---

# {{ page.title }}

**lsdoc** follows familiar [JavaDoc][javadoc] and [ASDoc][asdoc] conventions for parsing [api documentation](#/api "toggle the API sidebar") from metadata inside documentation comment blocks.
{:.larger.text}

- TOC
{::options toc_levels="2,3" /}
{:toc}

## Documentation comments

Source code is described in a documentation comment block (a multi-line comment beginning with two asterisks: `/** ... */`) on the line above the subject:

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
Conventionally in generated documentation, main descriptions are rendered where a short form is necessary, and detailed descriptions are included where a long form is appropriate.

### Code snippets

To include code snippets in documentation comments, use the fenced markdown syntax (with optional language hint) within the documentation comment:

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

**To preserve indentation, use the horizontal tab character (`⇥`).** The loomscript compiler strips whitespace when compiling a loomlib, but the lsdoc processor will replace horizontal tab characters with a predefined indent (two spaces, by default; see the [code_indent][code-indent] site variable).
{:.ui.large.warning.message}


## Documentation subjects

The following constructs can be documented in LoomScript:

| _construct_  | syntax                             |
|--------------|------------------------------------|
| _Types_      | `class`, `interface`, `struct`     |
| _Methods_    | `function`, `delegate`, `operator` |
| _Properties_ | `get`, `set`                       |
| _Fields_     | `var`, `const`                     |


## Tags

Tags supported by **lsdoc** start with the at sign (`@`) followed by a key, a space, and value: `@key value`.

Tags must always be on their own line.
Each tag is described in more detail in the following sections.

| tag        | syntax | effect |
|------------|--------|--------|
| copy       | `@copy <source>` | duplicates the description from a named source |
| deprecated | `@deprecated <since-version>` | marks the subject with a deprecated label |
| param      | `@param <description>` | adds a parameter description to the method details table |
| return     | `@return <description>` | adds a _returns_ description row to the method details table |
| see        | `@see <target>` | creates a hyperlink to the specified target url |


### @copy

Usage: `@copy <source>`

Re-use a description already defined by `<source>`, e.g. from an interface, or a parent class.
The source value must be a fully qualified package (e.g. `example.ExampleSuperClass`), with a member named identically to the documentation subject.

```as3
/**
@copy example.ExampleSuperClass#parent_field

Additional doc comments (optional)
*/
public var my_field:String = 'foo';
```

### @deprecated

Usage: `@deprecated <since-version>`

Mark the documentation subject with a deprecated label.

```as3
/**
@deprecated v2.1.3
*/
public function get legacy_property():String;
```

### @param

Usage: `@param <name⎵description>`

Describe a method parameter. Include one `@param` line for each parameter.

The parameter name is expected as the first part of the description, separated from the rest by a single space.

```as3
/**
@param param1 The first parameter
@param rest Optional additional params
*/
public function my_method(param1:String, ...rest):void;
```

### @return

Usage: `@return <description>`

Describe the return value.

```as3
/**
@return A `Dictionary` of `String` keys and `Number` values.
*/
public function get templated_property():Dictionary.<String,Number> { return null; }
```

### @see

Usage: `@see <target>`

Create hyperlinks to members, types, and general web targets.

Use an octothorpe (`#`) to specify a member of a type.
If a fully qualified type is not provided, the current type is assumed.

```as3
/**
@see #localMethod
@see example.ExampleInterface
@see example.ExampleInterface#method
@see http://foo.bar.baz
*/
```


## Examples

Compare the source code files included with the lsdoc library and the resultant documentation on this site:

[source][example-src] &rarr; [result][example-docs]
{:.larger.text}



[asdoc]: http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html "Creating ASDoc comments in ActionScript"
[code-indent]: https://pixeldroid.com/programming-pages/guides/Installing-the-theme/Theme-files/#user-provided-configuration "Use code_indent to set the indentation of documentation code snippets"
[example-docs]: {{site.baseurl}}/api/example/#/api/ "documentation of example source code comments"
[example-src]: https://github.com/pixeldroid/lsdoc/tree/master/lib/src/example "example source code comments"
[javadoc]: http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html "How to Write Doc Comments for the Javadoc Tool"
