# CVS Parser

### State machine

| Current State | Condition | Next State | Notes |
| --- | --- | --- | --- |
| | Initial state | lineStart | |
| lineStart | `ws`<sup>[1](#fn1)</sup> | lineStart | |
|  | `"` | quoted | Add a new row |
|  | `,`<sup>[2](#fn2)</sup> | fieldStart | Add a new row and add an empty field |
|  | else | normal | Add a new row and add character to text field |
| fieldStart | `nl`<sup>[3](#fn3)</sup>| lineStart | Add an empty field to the last row |
| | `ws` | fieldStart | `ws` excluding `nl` |
| | `"` | quoted | Start quoted field |
| | `,` | fieldStart | Add an empty field to the last row |
| | else | normal | |
| normal | `"` | quoted | Start quoted |
| | `,` | fieldStart | Add a new field to the last row |
| | `nl` | lineStart | Add a new field to the last row |
| | `cr`<sup>[4](#fn4)</sup> | normal | skip |
| | else | normal | Add character to field text |
| quoted | `"` | qdfound | |
| | else | quoted | Add character to field text |
| qdfound | `"` | quoted | Single `"` added to text |
| | else | normal | Add character to field text |

### Footnotes

- <a id="fn1">1</a> `ws` is an abreviation for whitespace, it has many meanings but here
it means carriage return, new line or, space.
- <a id="fn2">2</a> The parser can handle other field separators than a comma but it is the default.
- <a id="fn3">3</a> `nl` is an abreviation for new line, it is used to terminate a line of text together with `cr`.
- <a id="fn4">4</a> `cr` is an abreviation for carriage return.
