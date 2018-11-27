---
layout: page
title: Analyzing loomlibs
---

# {{ page.title }}

Arbitrary static analysis of loomlibs is supported via custom processors that extend the lsdoc library.
{:.larger.text}

For a simple example, see the implementation of `InfoProcessor` included with lsdoc:

- [pixeldroid.lsdoc.processors.InfoProcessor]
- [pixeldroid.lsdoc.processors.tasks.info.GenerateModuleInfo]
- [pixeldroid.lsdoc.processors.tasks.info.WriteModuleInfo]



[pixeldroid.lsdoc.processors.InfoProcessor]: https://github.com/pixeldroid/lsdoc/blob/master/lib/src/pixeldroid/lsdoc/processors/InfoProcessor.ls "source code for InfoProcessor.ls"
[pixeldroid.lsdoc.processors.tasks.info.GenerateModuleInfo]: https://github.com/pixeldroid/lsdoc/blob/master/lib/src/pixeldroid/lsdoc/processors/tasks/info/GenerateModuleInfo.ls "source code for GenerateModuleInfo.ls"
[pixeldroid.lsdoc.processors.tasks.info.WriteModuleInfo]: https://github.com/pixeldroid/lsdoc/blob/master/lib/src/pixeldroid/lsdoc/processors/tasks/info/WriteModuleInfo.ls "source code for WriteModuleInfo.ls"
