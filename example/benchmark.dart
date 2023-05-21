import 'package:csv/csv.dart';
import 'package:serial_csv/serial_csv.dart';

void main() {
  benchmarkParseStrings();
}

void benchmarkParseTyped() {
  const segment = '"ae5szjmznteje3wT","bwZshH!?dhdrj","cqwe332tjszzkt2L"\n13143,2.43,"-33"\n-4,,true\n';
  final input = List<String>.generate(1000, (index) => segment).join('');
  const iterations = 2000;

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(input),
  );

  _benchmark(
    name: 'CsvToListConverter.convert',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(input),
  );
}

void benchmarkParseStrings() {
  const segment = '"awt4Gw5hbwggTVBD4WWAVdds15","5hweh?!","feWg--adw!"\n"eee;;;www2","234rw","wgr5"\n"wss","nnnn","=?!wttTD"\n';
  final input = List<String>.generate(1000, (index) => segment).join('');
  const iterations = 2000;

  _benchmark(
    name: 'SerialCsv.decode',
    iterations: iterations,
    func: () => SerialCsv.decode(input),
  );

  _benchmark(
    name: 'SerialCsv.decodeStringList',
    iterations: iterations,
    func: () => SerialCsv.decodeStringList(input),
  );

  _benchmark(
    name: 'CsvToListConverter.convert',
    iterations: iterations,
    func: () => const CsvToListConverter(eol: '\n').convert(input),
  );
}

void benchmarkEncode() {
  const iterations = 2000;
  const row = ['rtdh56e6ew253', 'b32r21!424', 'cerges!!"r', 234, true];
  final input = List.generate(1000, (_) => row);

  _benchmark(
    name: 'SerialCsv.encode',
    iterations: iterations,
    func: () => SerialCsv.encode(input),
  );

  _benchmark(
    name: 'ListToCsvConverter.convert',
    iterations: iterations,
    func: () => const ListToCsvConverter().convert(input),
  );
}

void benchmarkEncodeStrings() {
  const iterations = 2000;
  const row = ['rtdh56e6ew253', 'b32r21!424', 'cerges!!"r', '234', 'true'];
  final input = List.generate(1000, (_) => row);

  _benchmark(
    name: 'SerialCsv.encodeStringList',
    iterations: iterations,
    func: () => SerialCsv.encodeStringList(input),
  );

  _benchmark(
    name: 'ListToCsvConverter.convert',
    iterations: iterations,
    func: () => const ListToCsvConverter().convert(input),
  );
}

void _benchmark<T>({
  required String name,
  required int iterations,
  required T Function() func,
  bool printResult = false,
}) {
  if (printResult) {
    print(func());
    return;
  }

  final stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    func();
  }
  stopwatch.stop();
  print('$name: ${stopwatch.elapsedMilliseconds}ms');
}

// void _printTypes(List<List<dynamic>> result) {
//   for (int row = 0; row < result.length; row++) {
//     for (int col = 0; col < result[row].length; col++) {
//       print('decoded[$row][$col]: ${result[row][col]} (${result[row][col].runtimeType})');
//     }
//   }
// }
