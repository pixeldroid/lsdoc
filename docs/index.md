---
layout: page
title: lsdoc
---

**lsdoc** is a command line app and library for extracting data from [loomlibs][loomlibs], the linkable code archives of [LoomScript][loomscript].
{:.larger.text}

By pairing **lsdoc** with a [processor][processors], the loomlib data can be used to do things like: [generate code documentation][lsdoc-document] or [perform static analysis][lsdoc-analyze] of the library.
{:.larger.text}

<span>{% include icon.liquid id='info-circle' %}</span> Use **lsdoc** with the [programming pages][programming-pages] template to easily generate clean technical documentation for LoomScript projects (like you're reading now), and host that documentation on GitHub Pages.
{:.ui.info.message}

## learn more

- browse the [api docs](#/api "toggle the API sidebar")
- read the [guides](#/guides "toggle the Guides sidebar")
- check out the [examples](#/examples "toggle the Examples sidebar")



[loomlibs]: {{site.baseurl}}/guides/Understanding-the-lsdoc-library/Anatomy-of-a-loomlib/#/guides/ "Anatomy of a loomlibs"
[loomscript]: https://github.com/LoomSDK/LoomSDK "The Loom SDK, a native mobile app and game framework"
[lsdoc-analyze]: {{site.baseurl}}/examples/analyzing/#/examples/ "using lsdoc and a custom processor to identify public interfaces without documentation"
[lsdoc-document]: {{site.baseurl}}/examples/documenting/#/examples/ "using lsdoc to create documentation for github pages"
[processors]: {{site.baseurl}}/api/pixeldroid/lsdoc/processors/#/api/ "api docs for lsdoc processors"
[programming-pages]: https://github.com/pixeldroid/programming-pages "A site template for publishing code documentation to GitHub pages"
