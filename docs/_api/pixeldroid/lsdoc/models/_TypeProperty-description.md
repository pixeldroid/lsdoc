Encapsulates the data of a loomlib `property` declaration.

Loom properties are special methods that look like a field, but provide control over access and mutation:
- `function get foo()`
- `function set foo()` (optional, value is read-only when not defined)

Note that doc strings are only recorded from the getter definition.
