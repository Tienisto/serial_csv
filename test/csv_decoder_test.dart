import 'package:serial_csv/serial_csv.dart';
import 'package:test/test.dart';

void main() {
  group('csv decode tests', () {
    test('Should decode normally', () {
      final result = SerialCsv.decode('''"a",,"c"
1,2.3,true
''');

      expect(result, [
        ['a', null, 'c'],
        [1, 2.3, true],
      ]);
    });

    test('Should decode with quotes', () {
      final result = SerialCsv.decode('"a","b","""c"""a\n');

      expect(result, [
        ['a', 'b', '"c"a'],
      ]);
    });

    test('Should decode with commas', () {
      final result = SerialCsv.decode('"a","b","c,d"\n');

      expect(result, [
        ['a', 'b', 'c,d'],
      ]);
    });

    test('Should decode with newlines', () {
      final result = SerialCsv.decode('"a","b","c\nd"\n');

      expect(result, [
        ['a', 'b', 'c\nd'],
      ]);
    });

    test('Should decode surrogate pairs', () {
      final result = SerialCsv.decode('"a","b","c𠀀d"\n');

      expect(result, [
        ['a', 'b', 'c𠀀d'],
      ]);
    });
  });
}
