---
layout: guide-index
title: Publishing to GitHub Pages
---

Documentation generated with **lsdoc** is compatible with [GitHub Pages hosting][ghpages], so for projects whose source is already hosted on GitHub, publishing docs is as simple as running lsdoc and pushing a commit.
{:.larger.text}

## In a nutshell

1. **[Write documentation][write-documentation]**
  - Use [Markdown][markdown-syntax] (specifically, [kramdown][kramdown-syntax]), inside [code comments][describing-code] to create api documentation, or in stand-alone text files to create [guides and examples][creating-guides+examples].
1. **[Run lsdoc][run-lsdoc]**
  - Use the `ghpages` processor to generate ready-to-publish documentation in an output folder.
1. **[Push to GitHub][push-to-github]**
  - Configure your GitHub repo to render the output folder as your project documentation site.
{:.ui.message}



[creating-guides+examples]: /guides/Writing-Documentation/Creating-guides-and-examples/#/guides/ "Creating guides and examples"
[describing-code]: /guides/Writing-Documentation/Describing-code/#/guides/ "Describing code with documentation comments"
[ghpages]: https://pages.github.com/ "Websites for you and your projects"
[kramdown-syntax]: https://kramdown.gettalong.org/syntax.html "kramdown syntax documentation"
[markdown-syntax]: https://guides.github.com/features/mastering-markdown/ "Markdown is a lightweight markup language with plain text formatting syntax"
[push-to-github]: /guides/Publishing-to-GitHub-Pages/Pushing-to-GitHub/#/guides/ "Pushing generated documentation to GitHub for rendering and hosting"
[run-lsdoc]: /guides/Publishing-to-GitHub-Pages/Running-lsdoc/#/guides/ "Running lsdoc to generate documentation"
[write-documentation]: /guides/Writing-Documentation/#/guides/ "Writing documentation to be processed by lsdoc"
