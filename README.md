# CSVParser

This package parses CSV files following [RFC-4180](https://tools.ietf.org/html/rfc4180).
It is much more tolerant than described there but that shouldn't be a problem.

### Limitations

1. The input and output must fit in memory at the same time.
2. The column seperator mustn't be a part of a Unicode sequence e.g. 1️⃣ consists of 3 characters, `1`, VS-16 and  ⃣
(the enclosing keycap). If for some reason you wanted to use `1` as the field separator and  1️⃣ was in one of the fields
then your text isn't going to look right. If you stick to comma, tab or, semicolon there shouldn't be a problem.
