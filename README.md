# serial_csv

[![pub package](https://img.shields.io/pub/v/serial_csv.svg)](https://pub.dev/packages/serial_csv)
![ci](https://github.com/Tienisto/serial_csv/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

High performance CSV encoder and decoder with retained types and nullability.

## Introduction

This package is intended to quickly encode and decode csv while keeping all type information.

Its strict nature enhances performance during encoding and decoding.

During this process, the following data types are preserved: `String`, `int`, `double`, `bool`, `null`.

## Benchmark

The benchmark consists of 2 million rows (1000 rows x 2000 iterations) running on an i7-10750H.

For comparison, the packages [csv](https://pub.dev/packages/csv) (v5.0.2),
[fast_csv](https://pub.dev/packages/fast_csv) (v0.1.44),
and [csvwriter](https://pub.dev/packages/csvwriter) (v1.3.0) were used.

![benchmark](https://raw.githubusercontent.com/Tienisto/serial_csv/main/assets/benchmark.png)

You can run the benchmark yourself with this [code example](https://github.com/Tienisto/serial_csv/blob/main/example/benchmark.dart).

## CSV structure

This library uses a more strict CSV format to achieve high performance.

- string cells are always double-quoted
- numeric and boolean cells are not double-quoted
- null cells are encoded as empty strings
- double-quotes within cells are escaped with another double-quote
- cells are separated by commas
- every row must be terminated with `\n` (LF)
- no comments (`#`) are allowed

## Usage

While the encoded CSV is still valid CSV, do not modify it with other tools as you might break the strict format.

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

### Specialization

There are specialized methods with optimized performance:

**Strings only**

Encode and decode a list of rows with only string cells. No `null` is allowed.

```dart
const rows = [
  ['a', 'b', 'c'],
  ['1', '2', '3'],
  ['4', '5', 'true'],
];
String encoded = SerialCsv.encodeStringList(rows);
List<List<String>> decoded = SerialCsv.decodeStringList(encoded);
```

**Key-Value**

Encode and decode a non-nested map. Keys must be strings. Values can be any supported type.

```dart
const map = {
  'a': '1',
  'b': 2,
  'c': true,
  'd': null,
};

String encoded = SerialCsv.encodeMap(map);
Map<String, dynamic> decoded = SerialCsv.decodeMap(encoded);
```
