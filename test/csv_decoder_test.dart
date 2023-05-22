import 'package:serial_csv/serial_csv.dart';
import 'package:test/test.dart';

void main() {
  group('SerialCsvDecoder.decode', () {
    test('Should decode single string', () {
      final result = SerialCsv.decode('"a"\n');

      expect(result, [
        ['a'],
      ]);
    });

    test('Should decode empty string', () {
      final result = SerialCsv.decode('""\n');

      expect(result, [
        ['']
      ]);
    });

    test('Should decode multiple empty strings', () {
      final result = SerialCsv.decode('"","",""\n""\n""\n');

      expect(result, [
        ['', '', ''],
        [''],
        [''],
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
      final result = SerialCsv.decode('"a","b","""c""a"\n');

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

    test('Should decode (integration test)', () {
      final result = SerialCsv.decode('''"a",,"c"
1,2.3,true
,,,
-3.22
"hello""world"
false,4,""
-2.3e-4
''');

      expect(result, [
        ['a', null, 'c'],
        [1, 2.3, true],
        [null, null, null, null],
        [-3.22],
        ['hello"world'],
        [false, 4, ''],
        [-2.3e-4],
      ]);
    });
  });

  group('SerialCsvDecoder.decodeStrings', () {
    test('Should decode single string', () {
      final result = SerialCsv.decodeStrings('"a"\n');

      expect(result, [
        ['a'],
      ]);
    });

    test('Should decode with quotes', () {
      final result = SerialCsv.decodeStrings('"a","b","""c""a"\n');

      expect(result, [
        ['a', 'b', '"c"a'],
      ]);
    });

    test('Should decode with commas', () {
      final result = SerialCsv.decodeStrings('"a","b","c,d"\n');

      expect(result, [
        ['a', 'b', 'c,d'],
      ]);
    });

    test('Should decode with newlines', () {
      final result = SerialCsv.decodeStrings('"a","b","c\nd"\n');

      expect(result, [
        ['a', 'b', 'c\nd'],
      ]);
    });

    test('Should decode surrogate pairs', () {
      final result = SerialCsv.decodeStrings('"a","b","c𠀀d"\n');

      expect(result, [
        ['a', 'b', 'c𠀀d'],
      ]);
    });

    test('Should decode (integration test)', () {
      final result = SerialCsv.decodeStrings('''"a","b11","c"
"ddd","ee","fff"
"g","h","i"
"hello""world"
''');

      expect(result, [
        ['a', 'b11', 'c'],
        ['ddd', 'ee', 'fff'],
        ['g', 'h', 'i'],
        ['hello"world'],
      ]);
    });
  });

  group('SerialCsvDecoder.decodeIntegers', () {
    test('Integration test', () {
      final result = SerialCsv.decodeIntegers('''123124,34634,234249
3326,-345,3
235,358,-44
987
''');

      expect(result, [
        [123124, 34634, 234249],
        [3326, -345, 3],
        [235, 358, -44],
        [987],
      ]);
    });
  });

  group('SerialCsvDecoder.decodeDoubles', () {
    test('Integration test', () {
      final result = SerialCsv.decodeDoubles('''123124.234,34634.234,234249.234
3326.234,-345.234,3.234
235.234,358.234,-44.234
987.234
''');

      expect(result, [
        [123124.234, 34634.234, 234249.234],
        [3326.234, -345.234, 3.234],
        [235.234, 358.234, -44.234],
        [987.234],
      ]);
    });
  });

  group('SerialCsvDecoder.decodeBooleans', () {
    test('Integration test', () {
      final result = SerialCsv.decodeBooleans('''true,false,true
false,true,false
true,true,false
false
''');

      expect(result, [
        [true, false, true],
        [false, true, false],
        [true, true, false],
        [false],
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
"b",2345
"c",23.45
"d",true
"e",false
"f",
''');

      expect(result, {
        'a': 'aa',
        'b': 2345,
        'c': 23.45,
        'd': true,
        'e': false,
        'f': null,
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
      final result = SerialCsv.decodeMap('"a","""b"""\n"""c""","d"\n');

      expect(result, {
        'a': '"b"',
        '"c"': 'd',
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
