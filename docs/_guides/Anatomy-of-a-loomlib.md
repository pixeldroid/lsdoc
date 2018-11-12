---
layout: page
title: Anatomy of a loomlib
---

# {{ page.title }}
{:.no_toc}

A **loomlib** is a self-contained, portable code library for the [LoomScript][loomscript] language. Loomlibs can be dynamically loaded into the LoomScript virtual machine at runtime (see [loading loomlibs][loading-loomlibs]), or statically linked against at compile time (see [linking loomlibs][linking-loomlibs]).
{:.larger.text}

Loomlibs are valid [json][json] files, containing [Base64][base64] encoded bytecode, documentation comments, and type metadata.

See the sections below for details of the data structures found in a loomlib.

- TOC
{:toc}

# assemblies

> type: `ASSEMBLY` <br>
> top level structure, synonymous with a `.loomlib` file

```json
{
  "debugbuild":true,
  "jit":true,
  "loomconfig":"...",
  "modules":[],
  "name":"...",
  "references":[],
  "type":"ASSEMBLY",
  "uid":"...",
  "version":"..."
}
```

substructures
- [modules](#modules)
- [references](#references)


## modules

> type: `MODULE` <br>
> typically (always?) one per [assembly](#assemblies)

```json
"modules": [
  {
    "dependencies":[],
    "name":"...",
    "type":"MODULE",
    "types":[],
    "version":"..."
  }
]
```

substructures
- [dependencies](#dependencies)
- [types](#types)


### dependencies

> ?? ever used?

### types

> type: `CLASS`, `DELEGATE`, `ENUM`, `INTERFACE`, `STRUCT`

```json
"types": [
  {
    "baseType": "...",
    "bytecode_instanceinitializer": "<base64>",
    "bytecode_instanceinitializer_fr2": "<base64>",
    "bytecode_staticinitializer": "<base64>",
    "bytecode_staticinitializer_fr2": "<base64>",
    "classattributes": [],
    "constructor": {},
    "delegateReturnType": null,
    "delegateTypes": [],
    "docString": "...",
    "fields": [],
    "imports": [],
    "interfaces": [],
    "line": 0,
    "metainfo": {},
    "methods": [],
    "name": "...",
    "package": "...",
    "properties": [],
    "source": "...",
    "type": "CLASS|DELEGATE|ENUM|INTERFACE|STRUCT",
    "typeid": 0
  }
]
```

substructures
- [classattributes](#classattributes)
- constructor (a [method](#methods) of type `CONSTRUCTOR`)
- [delegateReturnType](#delegateReturnType)
- [delegateTypes](#delegateTypes)
- [docString](#docString)
- [fields](#fields)
- [imports](#imports)
- [interfaces](#interfaces)
- [metainfo](#metainfo)
- [methods](#methods)
- [properties](#properties)


#### classattributes

> annotations for class access and mutability <br>
> `final`, `private`, `public`, `static`

```json
"classattributes": "final|private|public|static"
```

#### constructor

> a [method](#methods) of type: `CONSTRUCTOR`

#### delegateReturnType

> a fully qualified type string, or `null` if no return <br>
> e.g. `"system.Number"` or `null`

```json
"delegateReturnType": null,
"delegateReturnType": "<f.q.type>"
```

#### delegateTypes

> array of fully qualified type strings used in delegate signature

```json
"delegateTypes":[
  "<f.q.type>",
  "<f.q.type>"
]
```

#### fields

> variables and constants <br>
> see [properties](#properties) for getters and setters

```json
"fields":[
  {
    "docString":"...",
    "fieldattributes":[],
    "line":0,
    "metainfo":{},
    "name":"...",
    "ordinal":0,
    "source":"...",
    "templatetypes":null,
    "type":"..."
  }
]
```

substructures
- [docString](#docString)
- [fieldattributes](#fieldattributes)
- [metainfo](#metainfo)
- [templatetypes](#templatetypes)


##### fieldattributes

> `const`, `native`, `private`, `protected`, `public`, `static`

```json
"fieldattributes": "const|native|private|protected|public|static"
```


#### imports

> types linked with `import` directive <br>
> NOTE: this is not a reliable indication of dependencies; it comes verbatim from the source file and may include unused references

```json
"imports":[
  "<f.q.type>",
  "<f.q.type>"
]
```

#### interfaces

> `interface` types referenced via `extends` or `implements`

```json
"interfaces":[
  "<f.q.type>",
  "<f.q.type>"
]
```

#### properties

> getters and setters <br>
> see [fields](#fields) for variables and constants

```json
"properties":[
  {
    "docString":"...",
    "getter":{},
    "line":0,
    "metainfo":{},
    "name":"...",
    "ordinal":0,
    "propertyattributes":[],
    "setter":{},
    "source":"...",
    "templatetypes":null,
    "type":"..."
  }
]
```

substructures
- [docString](#docString)
- getter (a [method](#methods) of type `METHOD` with no parameters that returns `type`)
- [metainfo](#metainfo)
- [propertyattributes](#propertyattributes)
- setter (a [method](#methods) of type `METHOD` with parameter of `type` and no return value)
- [templatetypes](#templatetypes)


##### propertyattributes

> annotations for property access and scope <br>
> `private`, `protected`, `public`, `static`

```json
"propertyattributes": "private|protected|public|static"
```


## references

> linkage dependencies (other loomlibs) <br>

```json
"references":[
  {
     "name":"System"
  },
  {
     "name":"Loom"
  }
]
```


# common data structures

Data structures shared at multiple levels

## docString

> documentation strings extracted from doc comment fields (`/** .. */`). unicode is supported. <br>
> NOTE: comment fields are associated with the construct they preceed. blank lines between a comment field and a target construct will break the association. <br>
> NOTE: during extraction, whitespace is collapsed and newlines and double quotes are escaped

```json
"docString":"..."
```

## metainfo

> arbitrary annotations for use with the reflection API <br>
> built-in support: `Inject`, `Bind`, `Native`, `Deprecated` <br>
> custom: `[MyMetadata(flagKey, key1=value1, key2=value2)]` (see [Reflection Guide][loomdocs-reflection])

```json
"metainfo":{
  "Native":[
    [
      "managed",
      ""
    ]
  ]
}
```

## methods

> callable sub-routines <br>
> type: `CONSTRUCTOR`, `METHOD`

```json
"methods":[
  {
    "bytecode":"<base64>",
    "bytecode_fr2":"<base64>",
    "docString":"...",
    "line":0,
    "metainfo":{},
    "methodattributes":[],
    "name":"...",
    "ordinal":0,
    "parameters":[],
    "returntype":"...",
    "source":"...",
    "templatetypes":null,
    "type":"CONSTRUCTOR|METHOD"
  }
]
```

substructures
- [docString](#docString)
- [metainfo](#metainfo)
- [methodattributes](#methodattributes)
- [parameters](#parameters)
- [templatetypes](#templatetypes)


### methodattributes

> annotations for method access and scope <br>
> `native`, `operator`, `private`, `protected`, `public`, `static`, `supercall`

```json
"methodattributes": "native|operator|private|protected|public|static|supercall"
```

### parameters

> inputs to method calls <br>
> _typical_: `function f(p:Type):void` <br>
> _default_: `function f(p:Boolean=true):void` <br>
> _varargs_: `function f(...args):void` (type of `args` is always `Vector.<Object>`)

```json
"parameters":[
  {
    "hasdefault":false,
    "isvarargs":false,
    "name":"...",
    "templatetypes":null,
    "type":"..."
  },
  {
    "defaultvalue":"...",
    "hasdefault":true,
    "isvarargs":false,
    "name":"...",
    "templatetypes":null,
    "type":"..."
  },
  {
    "hasdefault":false,
    "isvarargs":true,
    "name":"...",
    "templatetypes":{
      "type":"system.Vector",
      "types":[
        "system.Object"
      ]
    },
    "type":"system.Vector"
  }
]
```


## templatetypes

> templated container types, i.e. `Vector` (array) or `Dictionary` (map) <br>
> type: `system.Vector`, `system.Dictionary`

**`:Vector.<Object>`**

```json
"templatetypes":{
  "type":"system.Vector",
  "types":[
    "system.Object"
  ]
}
```

**`:Dictionary.<String,Object>`**

```json
"templatetypes":{
  "type":"system.Dictionary",
  "types":[
    "system.String",
    "system.Object"
  ]
}
```

Nested types are valid. For example, a mapping of Type to array of Objects:

**`:Dictionary.<Type,Vector.<Object>>`**

```json
"templatetypes":{
  "type":"system.Dictionary",
  "types":[
    "system.reflection.Type",
    {
      "type":"system.Vector",
      "types":[
        "system.Object"
      ]
    }
  ]
}
```


[base64]: https://en.wikipedia.org/wiki/Base64 "base64 encoding"
[json]: https://www.json.org/ "Introducing JSON - javascript object notation"
[linking-loomlibs]: /foo "statically link a loomlib into a project with the loomscript compiler"
[loading-loomlibs]: /foo "dynamically load a loomlib into the running LoomScript VM"
[loomscript]: https://github.com/LoomSDK/LoomSDK "The Loom SDK, a native mobile app and game framework"
[loomdocs-reflection]: http://docs.theengine.co/loom/1.1.4813/guides/02_LoomScript/03_reflection.html "Reflection in LoomScript"
