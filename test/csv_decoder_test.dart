import 'package:serial_csv/serial_csv.dart';
import 'package:test/test.dart';

void main() {
  group('SerialCsvDecoder.decode', () {
    test('Should decode normally', () {
      final result = SerialCsv.decode('''"a",,"c"
1,2.3,true
''');

      expect(result, [
        ['a', null, 'c'],
        [1, 2.3, true],
      ]);
    });

    test('Should decode with nulls', () {
      final result = SerialCsv.decode('''"a",,"null"
1,"null",
,,
''');

      expect(result, [
        ['a', null, 'null'],
        [1, 'null', null],
        [null, null, null],
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

  group('SerialCsvDecoder.decodeStringList', () {
    test('Should decode normally', () {
      final result = SerialCsv.decodeStringList('''"a","b11","c"
"ddd","ee","fff"
"g","h","i"
''');

      expect(result, [
        ['a', 'b11', 'c'],
        ['ddd', 'ee', 'fff'],
        ['g', 'h', 'i'],
      ]);
    });

    test('Should decode with quotes', () {
      final result = SerialCsv.decodeStringList('"a","b","""c"""a\n');

      expect(result, [
        ['a', 'b', '"c"a'],
      ]);
    });

    test('Should decode with commas', () {
      final result = SerialCsv.decodeStringList('"a","b","c,d"\n');

      expect(result, [
        ['a', 'b', 'c,d'],
      ]);
    });

    test('Should decode with newlines', () {
      final result = SerialCsv.decodeStringList('"a","b","c\nd"\n');

      expect(result, [
        ['a', 'b', 'c\nd'],
      ]);
    });

    test('Should decode surrogate pairs', () {
      final result = SerialCsv.decodeStringList('"a","b","c𠀀d"\n');

      expect(result, [
        ['a', 'b', 'c𠀀d'],
      ]);
    });
  });

  group('SerialCsvDecoder.decodeMap', () {
    test('Should decode a simple map', () {
      final result = SerialCsv.decodeMap('"a","aa"\n');

      expect(result, {
        'a': 'aa',
      });
    });

    test('Should decode normally', () {
      final result = SerialCsv.decodeMap('''"a","aa"
"b",2
"c",3.4
"d",true
"e",
''');

      expect(result, {
        'a': 'aa',
        'b': 2,
        'c': 3.4,
        'd': true,
        'e': null,
      });
      expect(result['b'], isA<int>());
      expect(result['c'], isA<double>());
    });

    test('Should decode mupltiple entries', () {
      final result = SerialCsv.decodeMap('"a","11"\n"b","22"\n');

      expect(result, {
        'a': '11',
        'b': '22',
      });
    });

    test('Should decode with quotes', () {
      final result = SerialCsv.decodeMap('"a","""b"""\n');

      expect(result, {
        'a': '"b"',
      });
    });

    test('Should decode with commas', () {
      final result = SerialCsv.decodeMap('"a","b,c"\n');

      expect(result, {
        'a': 'b,c',
      });
    });

    test('Should decode with newlines', () {
      final result = SerialCsv.decodeMap('"a","b\nc"\n');

      expect(result, {
        'a': 'b\nc',
      });
    });

    test('Should decode surrogate pairs', () {
      final result = SerialCsv.decodeMap('"a","b𠀀c"\n');

      expect(result, {
        'a': 'b𠀀c',
      });
    });
  });
}
