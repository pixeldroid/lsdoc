---
layout: page
title: Creating Documentation
---


# {{ page.title }}

The `lsdoc.example` package illustrates source code documentation for all the different supported types in [LoomScript][loomscript-types].
{:.larger.text}

The example documentation was generated for GitHub pages from source code comments in LoomScript files that were compiled into a loomlib and processed by lsdoc using a command like the following:

```console
$ lsdoc -p ghpages \
    -t <template_dir}> \
    -l <loomlib_path> \
    -o <out_dir}> \
    -c <config_path}> \
    -i <in_dir>/index.md
```

See the [package summary][lsdoc-example] or browse from here:

{% for collection in site.collections %}
{% if collection.label == 'api' %}
{% assign doc_list = collection.docs | where:'module','example' %}
{% endif %}
{% endfor %}
{% for doc in doc_list %}
  {% capture link %}{{ doc.name }}{% endcapture %}
  {% capture url %}{{ doc.url }}#/{{ collection.label | downcase }}/{% endcapture %}
- [{{ link }}]({{ site.baseurl }}{{ url }})
{% endfor %}



[loomscript-types]: http://docs.theengine.co/loom/1.1.3435/guides/02_LoomScript/02_syntax.html "LoomScript language reference"
[lsdoc-example]: {{ site.baseurl }}/api/example/#/api/ "the lsdoc.example package illustrates source code documentation for all LoomScript types"
