---
layout: guide-index
title: Writing documentation
---

**lsdoc** follows familiar [JavaDoc][javadoc] and [ASDoc][asdoc] conventions to generate [api documentation](#/api "toggle the API sidebar"), [examples](#/examples "toggle the Examples sidebar"), and [guides](#/guides "toggle the Guides sidebar").
{:.larger.text}

## Usage

* Write documentation in [Markdown][markdown-syntax] (specifically, [kramdown][kramdown-syntax]), inside [code comments][describing-code], or in stand-alone text files.
* Run **lsdoc** with the `ghpages` processor to generate ready-to-publish documentation in an output folder (see the [Running lsdoc guide][run-lsdoc] for more details).
* Configure your GitHub repo to render the output folder as your project documentation site (see [Configuring a publishing source for GitHub Pages][ghpages-howto] for more details).



[asdoc]: http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bb7b-7fed.html "Creating ASDoc comments in ActionScript"
[describing-code]: /guides/Writing-Documentation/Describing-code/#/guides/ "Describing code with documentation comments"
[javadoc]: http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html "How to Write Doc Comments for the Javadoc Tool"
[kramdown-syntax]: https://kramdown.gettalong.org/syntax.html "kramdown syntax documentation"
[markdown-syntax]: https://guides.github.com/features/mastering-markdown/ "Markdown is a lightweight markup language with plain text formatting syntax"
[run-lsdoc]: /guides/Running-lsdoc/#/guides/ "Running lsdoc guide"
