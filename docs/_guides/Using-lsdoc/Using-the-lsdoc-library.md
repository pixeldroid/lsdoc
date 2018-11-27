---
layout: page
title: Using the lsdoc library
---

As a code library, lsdoc provides utilities to write code that reads loomlibs and extracts data from them, and provides processors to transform that data into some result, like documentation, or a report. Custom processors can also be written, leveraging the api provided by lsdoc library.
{:.larger.text}

<span>{% include icon.liquid id='check-circle' %}</span> Loomlibs are [JSON] format text files.<br>See their structure described in [Anatomy of a loomlib].
{:.ui.success.message}

The [LSDoc] class provides an entry point to load loomlibs for parsing, and then for retrieving populated data models.

Access to loomlib data is provided by the the following models, with [LibModule] at the root:

{% for collection in site.collections %}
{% if collection.label == 'api' %}
{% assign doc_list = collection.docs | where:'module','pixeldroid.lsdoc.models' %}
{% endif %}
{% endfor %}
{% for doc in doc_list %}
  {% capture link %}{{ doc.name }}{% endcapture %}
  {% capture url %}{{ doc.url }}#/{{ collection.label | downcase }}/{% endcapture %}
- [{{ link }}]({{ site.baseurl }}{{ url }})
{% endfor %}



[Anatomy of a loomlib]: {{site.baseurl}}/guides/Anatomy-of-a-loomlib/#/guides/ "documentation of the loomlib structure"
[JSON]: https://www.json.org/ "javascript object notation"
[LibModule]: {{site.baseurl}}/api/pixeldroid/lsdoc/models/LibModule/#/api/ "API docs for LibModule"
[LSDoc]: {{site.baseurl}}/api/pixeldroid/lsdoc/LSDoc/#/api/ "API docs for LSDoc"
