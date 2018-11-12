---
layout: page
title: Analyzing loomlibs
---


# {{ page.title }}

> convert to use the `example` layout

Arbitrary static analysis of loomlibs is supported via custom processors that extend the lsdoc library.
{:.larger.text}

In this example, the following processor itemizes all the public interface elements that are missing documentation.

```ls
public function foo():void {}
```
