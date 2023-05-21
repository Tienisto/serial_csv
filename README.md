# serial_csv

High performance CSV encoder and decoder with retained types and nullability.

## Introduction

This package is intended to quickly encode and decode csv while keeping all type information.

The strict nature allows for high performance during encoding and decoding.

The following data types are supported and retained: `String`, `int`, `double`, `bool`, `null`.

## Benchmark

The benchmark was run with 2 million rows (1000 rows x 2000 iterations) on an i7-10750H.

For comparison, the famous [csv](https://pub.dev/packages/csv) package was used.

![benchmark](https://raw.githubusercontent.com/Tienisto/serial_csv/main/assets/benchmark.png)

You can run the benchmark yourself with this [code example](https://github.com/Tienisto/serial_csv/blob/main/example/benchmark.dart).

## CSV structure

- string cells are always double-quoted
- numeric and boolean cells are not double-quoted
- null cells are encoded as empty strings
- double-quotes within cells are escaped with another double-quote
- cells are separated by commas
- every row must be terminated with `\n` (LF)

## Usage

You can **decode** with any library but be careful to **encode** with other libraries as you might get an invalid format.

So as long as you only use this library, you can be sure that the data types and their nullability are retained.

```csv
"a","b","c"
1,2.3,"3"
4,,true
```

```dart
String encoded = SerialCsv.encode([
  ['a', 'b', 'c'],
  [1, 2.3, '3'],
  ['4', null, true],
]);

List<List<dynamic>> decoded = SerialCsv.decode(encoded);

String s = decoded[0][0]; // 'a'
int i = decoded[1][0]; // 1
double d = decoded[1][1]; // 2.3
bool b = decoded[2][2]; // true
Object? n = decoded[2][1]; // null
```

## API

### Encode

Encode a list of rows into a csv string.

Example:
```dart
const rows = [
  ['a', 'b', 'c'],
  [1, 2, 3.2],
  ['4', null, true],
];
String encoded = SerialCsv.encode(rows);
```

### Decode

Decode a csv string into a list of rows.

Example:
```dart
const csv = '"a","b","c"\n1,2.3,"3"\n4,,true\n';
List<List<dynamic>> decoded = SerialCsv.decode(csv);
```
