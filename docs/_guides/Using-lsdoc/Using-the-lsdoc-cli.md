---
layout: page
title: Using the lsdoc cli
---

As a command-line tool, lsdoc reads loomlibs and executes processors on them.
{:.larger.text}

The cli offers usage info when executed without arguments:

```console
$ lsdoc
usage: lsdoc [-h|--help] [-v|--version]
             -l|--lib <path>...
             -o|--output-dir <path>
             [-d|--debug]
             [-p|--processor <name>]

options:
  -h --help           Print this screen and exit
  -v --version        Print version and exit
  -d --debug          Turn on debug logging
  -l --lib <path>...  Add loomlib (multiple paths may be given)
  -o --output-dir     Set directory for output
  -p --processor      Select processor (info|ghpages)
```

When given a processor, and a loomlib, the tool reports errors and progress:

```console
$ lsdoc -l ~/.loom/sdks/sprint34/libs/Log.loomlib -p info
lsdoc 2.0.0
no output directory specified
$ lsdoc -l ~/.loom/sdks/sprint34/libs/LSDoc.loomlib -p info -o ~/lsdoc/
lsdoc 2.0.0
running..
100% complete
done.
```

lsdoc currently ships with two processors:

- `info` - counts types in a loomlib and prints a simple text report
- `ghpages` - processes documentation comments to generate markdown files compatible with publishing to GitHub Pages. The [programming-pages] theme is used.

See [Describing code] for details about writing documentation comments for the GitHub Pages processor (`ghpages`).



[Describing code]: {{site.baseurl}}/guides/Using-lsdoc/Describing-code/#/guides/ "How to write doc comments for lsdoc"
[programming-pages]: https://github.com/pixeldroid/programming-pages "A jekyll theme for publishing code documentation to GitHub pages"
