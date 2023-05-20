# serial_csv

High performance CSV encoder and decoder with persisted type-safety and null-safety.

## Introduction

This package is intended to quickly encode and decode csv in an opinionated and type-safe way.

The strict nature allows for high performance encoding and decoding.

The following data types are supported: `String`, `int`, `double`, `bool`, `null`.

## CSV structure

- string cells are always double-quoted
- numeric and boolean cells are not double-quoted
- null cells are encoded as empty strings
- double-quotes within cells are escaped with another double-quote
- cells are separated by commas
- every row must be terminated with `\n` (LF)

## Usage

You can **decode** with any library but be careful to **encode** with other libraries as they might not follow the strict specification.

```dart
const csv = '"a","b","c"\n1,2.3,"3"\n4,,true\n';
List<List<Object?>> decoded = SerialCsv.decode(csv);
String encoded = SerialCsv.encode(decoded);
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
List<List<Object?>> decoded = SerialCsv.decode(csv);
```
