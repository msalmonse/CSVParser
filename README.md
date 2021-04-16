# CSVParser

This package parses CSV files following [RFC-4180](https://tools.ietf.org/html/rfc4180).
It is much more tolerant than described there but that shouldn't be a problem.

### API

csvParser can be called as:<br/>
`csvParse(csvText, separatedBy: ",", to: &csv, leavingWhiteSpace: false)`
or:<br/>
`csvParse(csvURL, separatedBy: ",", to: &csv, leavingWhiteSpace: false)`

Where csvText is the csv data as a string, csvURL is the location of a csv file and csv is an array of arrays
of string that will be filled with the fields from the input. `separatedBy` can be used to change the field 
separator from `,`. If `leavingWhiteSpace` is set to true then leading and trailing whitespace are left
untrimmed.

### Speed

100,000 lines of 7 fields of random numbers takes about .4 seconds to process on my M1 mini, leaving the spaces adds
about .2 seconds. A simple split of the text on newlines and then commas is about twice as fast, YMMV.

### Limitations

1. The input and output must fit in memory at the same time.
2. The column seperator mustn't be a part of a Unicode sequence e.g. 1️⃣ consists of 3 characters, `1`, VS-16 and  ⃣
(the enclosing keycap). If for some reason you wanted to use `1` as the field separator and  1️⃣ was in one of the fields
then your text isn't going to look right. If you stick to comma, tab or, semicolon there shouldn't be a problem.
