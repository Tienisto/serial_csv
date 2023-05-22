import 'dart:convert';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:csvwriter/csvwriter.dart';
import 'package:serial_csv/serial_csv.dart';
import 'package:fast_csv/fast_csv.dart' as fast_csv;

void main() {
  benchmarkParseStrings();
}

List<List> getTypedList() {
  return List.generate(
    1000,
    (index) => [
      ['ae5szjmz"nteje3wT', 'bwZshH!?dhdrj', '${'ka$index'.hashCode.toRadixString(16)}!'],
      [index.hashCode, 2.43, '-33'],
      [-4, null, true],
      [null, null, null],
      [false, index % 2 == 0, false],
    ],
  ).expand((element) => element).toList();
}

List<List<String>> getStringList() {
  return List.generate(
    1000,
    (index) => [
      ['ae5szjmz"nteje3wT', 'bwZshH!?dhdrj', '${'ka$index'.hashCode.toRadixString(16)}!'],
      ['aefew4t9z438"goGHUIHUIrqwe', 'RJ%U§)(u35wfesqqq', 'DEOFAFSAVka2411$index bb'],
      ['oas8fc9FU()AÖPPfa3JJKL§"" ', 'öwpod9elKKS${'gg$index'.hashCode}', '12312413432'],
      ['rODEO§)FLlFAQ!!!!&&&&', 'LLFWOPOSAPKOPWFF', 'aldsi9OP§FLSDNFKLew3332'],
      ['fsdfeoi${'aaa$index'.hashCode}---', 'owejftiw04380', 'pfojw0t9j03ow4pzjg9psw548gjw54'],
    ],
  ).expand((element) => element).toList();
}

List<List<int>> getIntList() {
  final random = Random();
  return List.generate(
    1000,
    (index) => List.generate(
      3,
      (index) => random.nextInt(1000) - 500,
    ),
  );
}

List<List<double>> getDoubleList() {
  final random = Random();
  return List.generate(
    1000,
    (index) => List.generate(
      3,
      (index) => random.nextDouble() * 1000 - 500.0,
    ),
  );
}

Map<String, dynamic> getMap() {
  return Map<String, dynamic>.fromEntries(List.generate(2000, (index) {
    final String key = 'k$index.hashCode'.hashCode.toRadixString(16);
    final dynamic value;
    switch (index % 6) {
      case 0:
        value = index.hashCode;
        break;
      case 1:
        value = index.hashCode.toRadixString(16);
        break;
      case 2:
        value = index.hashCode / 2;
        break;
      case 3:
        value = index.hashCode % 2 == 0;
        break;
      default:
        value = null;
        break;
    }
    return MapEntry(key, value);
  }));
}

void benchmarkParseTyped() {
  final inputStructured = getTypedList();
  final inputCsv = SerialCsv.encode(inputStructured);
  const iterations = 2000;

  _heatup(
    name: 'parse mixed types',
    iterations: iterations,
    functions: [
      () => SerialCsv.decode(inputCsv),
      () => fast_csv.parse(inputCsv),
      () => const CsvToListConverter(eol: '\n').convert(inputCsv),
      () => jsonDecode(jsonEncode(inputStructured)),
    ],
  );

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(inputCsv),
  );

  _benchmark(
    name: 'fast_csv',
    iterations: iterations,
    func: () => fast_csv.parse(inputCsv),
  );

  _benchmark(
    name: 'csv',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(inputCsv),
  );

  final encoded = jsonEncode(inputStructured); // encode only once
  _benchmark(
    name: 'jsonDecode',
    iterations: iterations,
    func: () => jsonDecode(encoded),
  );
}

void benchmarkParseStrings() {
  final inputStructured = getStringList();
  final inputCsv = SerialCsv.encode(inputStructured);
  const iterations = 2000;

  _heatup(
    name: 'parse strings',
    iterations: iterations,
    functions: [
      () => SerialCsv.decode(inputCsv),
      () => SerialCsv.decodeStrings(inputCsv),
      () => fast_csv.parse(inputCsv),
      () => const CsvToListConverter(eol: '\n').convert(inputCsv),
      () => jsonDecode(jsonEncode(inputStructured)),
    ],
  );

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(inputCsv).cast<List<String>>(),
  );

  _benchmark(
    name: 'SerialCsv.decodeStrings',
    iterations: iterations,
    func: () => SerialCsv.decodeStrings(inputCsv),
  );

  _benchmark(
    name: 'fast_csv',
    iterations: iterations,
    func: () => fast_csv.parse(inputCsv),
  );

  _benchmark(
    name: 'csv',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(inputCsv),
  );

  final encoded = jsonEncode(inputStructured); // encode only once
  _benchmark(
    name: 'jsonDecode',
    iterations: iterations,
    func: () => jsonDecode(encoded),
  );
}

void benchmarkParseInt() {
  final inputStructured = getIntList();
  final inputCsv = SerialCsv.encode(inputStructured);
  const iterations = 2000;

  _heatup(
    name: 'parse ints',
    iterations: iterations,
    functions: [
      () => SerialCsv.decode(inputCsv),
      () => SerialCsv.decodeIntegers(inputCsv),
      () => fast_csv.parse(inputCsv),
      () => const CsvToListConverter(eol: '\n').convert(inputCsv),
      () => jsonDecode(jsonEncode(inputStructured)),
    ],
  );

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(inputCsv).cast<List<int>>(),
  );

  _benchmark(
    name: 'SerialCsv.decodeIntegers',
    iterations: iterations,
    func: () => SerialCsv.decodeIntegers(inputCsv),
  );

  _benchmark(
    name: 'fast_csv',
    iterations: iterations,
    func: () => fast_csv.parse(inputCsv),
  );

  _benchmark(
    name: 'csv',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(inputCsv),
  );

  final encoded = jsonEncode(inputStructured); // encode only once
  _benchmark(
    name: 'jsonDecode',
    iterations: iterations,
    func: () => jsonDecode(encoded),
  );
}

void benchmarkParseDouble() {
  final inputStructured = getDoubleList();
  final inputCsv = SerialCsv.encode(inputStructured);
  const iterations = 2000;

  _heatup(
    name: 'parse doubles',
    iterations: iterations,
    functions: [
      () => SerialCsv.decode(inputCsv),
      () => SerialCsv.decodeDoubles(inputCsv),
      () => jsonDecode(jsonEncode(inputStructured)),
    ],
  );

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(inputCsv).cast<List<double>>(),
  );

  _benchmark(
    name: 'SerialCsv.decodeDoubles',
    iterations: iterations,
    func: () => SerialCsv.decodeDoubles(inputCsv),
  );

  final encoded = jsonEncode(inputStructured); // encode only once
  _benchmark(
    name: 'jsonDecode',
    iterations: iterations,
    func: () => jsonDecode(encoded),
  );
}

void benchmarkParseMap() {
  final map = getMap();
  final inputCsv = SerialCsv.encodeMap(map);
  const iterations = 2000;

  _heatup(
    name: 'parseMap',
    iterations: iterations,
    functions: [
      () => SerialCsv.decodeMap(inputCsv),
      () => fast_csv.parse(inputCsv),
      () => jsonDecode(jsonEncode(map)),
    ],
  );

  _benchmark(
    name: 'SerialCsv.decodeMap',
    iterations: iterations,
    func: () => SerialCsv.decodeMap(inputCsv),
  );

  _benchmark(
    name: 'SerialCsv.decode + map conversion',
    iterations: iterations,
    func: () {
      final result = SerialCsv.decode(inputCsv);
      return {
        for (var i = 0; i < result.length; i++) result[i][0]: result[i][1],
      };
    },
  );

  _benchmark(
    name: 'fast_csv (rows representation)',
    iterations: iterations,
    func: () => fast_csv.parse(inputCsv),
  );

  _benchmark(
    name: 'csv (rows representation)',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(inputCsv),
  );

  final encodedJson = jsonEncode(map);
  _benchmark(
    name: 'jsonDecode',
    iterations: iterations,
    func: () => jsonDecode(encodedJson),
  );
}

void benchmarkEncode() {
  final input = getTypedList();
  const iterations = 2000;

  _heatup(
    name: 'encode mixed types',
    iterations: iterations,
    functions: [
      () => SerialCsv.encode(input),
      () => const ListToCsvConverter().convert(input),
      () => jsonEncode(input),
    ],
  );

  _benchmark(
    name: 'SerialCsv.encode',
    iterations: iterations,
    func: () => SerialCsv.encode(input),
  );

  _benchmark(
    name: 'csvwriter',
    iterations: iterations,
    func: () {
      final buffer = StringBuffer();
      final writer = CsvWriter(buffer, 5, endOfLine: '\n');
      for (final row in input) {
        writer.writeData(data: row);
      }
      return buffer.toString();
    },
  );

  _benchmark(
    name: 'csv',
    iterations: iterations,
    func: () => const ListToCsvConverter().convert(input),
  );

  _benchmark(
    name: 'jsonEncode',
    iterations: iterations,
    func: () => jsonEncode(input),
  );
}

void benchmarkEncodeStrings() {
  final input = getStringList();
  const iterations = 2000;

  _heatup(
    name: 'encode strings',
    iterations: iterations,
    functions: [
      () => SerialCsv.encodeStrings(input),
      () => const ListToCsvConverter().convert(input),
    ],
  );

  _benchmark(
    name: 'SerialCsv.encodeStrings',
    iterations: iterations,
    func: () => SerialCsv.encodeStrings(input),
  );

  _benchmark(
    name: 'csvwriter',
    iterations: iterations,
    func: () {
      final buffer = StringBuffer();
      final writer = CsvWriter(buffer, 5, endOfLine: '\n');
      for (final row in input) {
        writer.writeData(data: row);
      }
      return buffer.toString();
    },
  );

  _benchmark(
    name: 'jsonEncode',
    iterations: iterations,
    func: () => jsonEncode(input),
  );

  _benchmark(
    name: 'csv',
    iterations: iterations,
    func: () => const ListToCsvConverter().convert(input),
  );
}

void benchmarkEncodeMap() {
  final map = getMap();
  const iterations = 3000;

  _heatup(
    name: 'encode map',
    iterations: iterations,
    functions: [
      () => SerialCsv.encodeMap(map),
      () => jsonEncode(map),
    ],
  );

  _benchmark(
    name: 'SerialCsv.encodeMap',
    iterations: iterations,
    func: () => SerialCsv.encodeMap(map),
  );

  _benchmark(
    name: 'jsonEncode',
    iterations: iterations,
    func: () => jsonEncode(map),
  );
}

void _benchmark<T>({
  required String name,
  required int iterations,
  required T Function() func,
  bool printResult = false,
}) {
  if (printResult) {
    final result = func();
    if (result is List<List>) {
      _printTypes2(result);
    } else if (result is List) {
      _printTypes(result);
    } else {
      print('Print result:');
      print(result.runtimeType);
      print(result);
    }
    return;
  }

  final stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    func();
  }
  stopwatch.stop();
  print('[${stopwatch.elapsedMilliseconds.toString().padLeft(5)} ms] $name');
}

void _heatup<T>({
  required String name,
  required int iterations,
  required List<T Function()> functions,
  bool printResult = false,
}) {
  print('Starting heat-up for "$name" ...');

  if (printResult) {
    print(functions.first());
    return;
  }

  final stopwatch = Stopwatch()..start();
  for (final fun in functions) {
    for (int i = 0; i < iterations; i++) {
      fun();
    }
  }
  stopwatch.stop();
  print('[${stopwatch.elapsedMilliseconds.toString().padLeft(5)} ms] heat-up');
}

void _printTypes(List<dynamic> result) {
  for (int i = 0; i < result.length; i++) {
    final row = result[i];
    if (row is List) {
      for (int j = 0; j < row.length; j++) {
        print('decoded[$i][$j]: ${row[j]} (${row[j].runtimeType})');
      }
    } else {
      print('decoded[$i]: $row (${row.runtimeType})');
    }
  }
}

void _printTypes2(List<List<dynamic>> result) {
  for (int row = 0; row < result.length; row++) {
    for (int col = 0; col < result[row].length; col++) {
      print('decoded[$row][$col]: ${result[row][col]} (${result[row][col].runtimeType})');
    }
  }
}
