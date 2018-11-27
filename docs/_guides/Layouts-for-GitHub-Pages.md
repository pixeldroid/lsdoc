---
layout: guide-index
title: Layouts for GitHub Pages

order: 2
---

**lsdoc** extends the [Programming Pages][programming-pages] theme by providing two layouts for LoomScript documentation: [package][layout-package] and [type][layout-type].
{:.larger.text}

<span>{% include icon.liquid id='info-circle' %} <b>Info</b></span><br> Layouts are essentially rendering functions. Given values for named parameters, the layout code turns those values into a specific html view.
{:.ui.info.message}

To use a layout, create a markdown or html file that has a yaml front-matter block at the top of the file, and provide values for the layout parameters within the front-matter block:

```yaml
---
layout: "package"
module: "example"

classes:
  - { declaration: "example/ExampleClass.ls", description: "Class description doc comments first line.\n\nAdditional class description documentation comments.\n\nCode sample:\n```as3\nvar c:ExampleClass = new ExampleClass();\n```", name: "ExampleClass" }
  - { declaration: "example/ExampleSuperClass.ls", description: "SuperClass description doc comments first line.\n\nAdditional class description documentation comments.", name: "ExampleSuperClass" }
delegates:
  - { declaration: "example/ExampleDelegate.ls", description: "Delegate method doc comments first line.\n\nThis method has one required parameter.", name: "ExampleDelegate" }
  - { declaration: "example/ExampleDelegate.ls", description: "Another delegate's method doc comments first line.\n\nThis method has three required parameters and returns a `Boolean`.", name: "OtherExampleDelegate" }
enums:
  - { declaration: "example/ExampleEnum.ls", description: "Enum doc comments first line.\n\nThis enumeration starts at zero and counts by ones,\nand has a `LAST` entry with value `999`.\n\nThe individual values can have their own doc comments.", name: "ExampleEnum" }
interfaces:
  - { declaration: "example/ExampleInterface.ls", description: "Interface description doc comments first line.\n\nAdditional interface description documentation comments.", name: "ExampleInterface" }
structs:
  - { declaration: "example/ExampleStruct.ls", description: "Struct description doc comments first line.\n\nAdditional struct description documentation comments.", name: "ExampleStruct" }
...
```

`example.md`
{:.smaller.text}

<span>{% include icon.liquid id='check-circle' %}</span> While you can author documentation by hand using these layouts, **lsdoc** provides the `ghpages` processor to build documentation pages automatically from a loomlib file. See [Describing code] and [Using the lsdoc cli] for more details.
{:.ui.success.message}



[Describing code]: {{site.baseurl}}/guides/Using-lsdoc/Describing-code/#/guides/ "How to mark up code for documentation generation"
[layout-package]: {{site.baseurl}}/guides/Layouts-for-GitHub-Pages/package/#/guides/ "Documentation of the package layout"
[layout-type]: {{site.baseurl}}/guides/Layouts-for-GitHub-Pages/type/#/guides/ "Documentation of the type layout"
[programming-pages]: https://github.com/pixeldroid/programming-pages "A site template for publishing code documentation to GitHub pages"
[Using the lsdoc cli]: {{site.baseurl}}/guides/Using-lsdoc/Using-the-lsdoc-cli/#/guides/ "Use the lsdoc cli to generate github pages documentation from loomlibs"
