import 'package:serial_csv/serial_csv.dart';
import 'package:test/test.dart';

void main() {
  group('SerialCsv.encode', () {
    test('Should encode normally', () {
      final result = SerialCsv.encode([
        ['a', 'b', 'c'],
        ['1', '2', '3'],
      ]);

      expect(result, '"a","b","c"\n"1","2","3"\n');
    });

    test('Should encode with quotes', () {
      final result = SerialCsv.encode([
        ['a', 'b', '"c"'],
      ]);

      expect(result, '"a","b","""c"""\n');
    });

    test('Should encode with newlines', () {
      final result = SerialCsv.encode([
        ['a', 'b', 'c\nd'],
      ]);

      expect(result, '"a","b","c\nd"\n');
    });

    test('Should not add double-quotes for numbers and booleans', () {
      final result = SerialCsv.encode([
        ['a', 'b', 'c'],
        [1, 2.3, true],
      ]);

      expect(result, '"a","b","c"\n1,2.3,true\n');
    });

    test('Should encode with nulls', () {
      final result = SerialCsv.encode([
        ['a', 'b', null],
      ]);

      expect(result, '"a","b",\n');
    });
  });

  group('SerialCsv.encodeStringList', () {
    test('Should encode normally', () {
      final result = SerialCsv.encodeStringList([
        ['a', 'b', 'c'],
        ['1', '2', '3'],
      ]);

      expect(result, '"a","b","c"\n"1","2","3"\n');
    });

    test('Should encode with quotes', () {
      final result = SerialCsv.encodeStringList([
        ['a', 'b', '"c"'],
      ]);

      expect(result, '"a","b","""c"""\n');
    });

    test('Should encode with newlines', () {
      final result = SerialCsv.encodeStringList([
        ['a', 'b', 'c\nd'],
      ]);

      expect(result, '"a","b","c\nd"\n');
    });
  });
}
