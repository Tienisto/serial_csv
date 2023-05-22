import 'package:serial_csv/src/csv_decoder.dart';
import 'package:serial_csv/src/csv_encoder.dart';

class SerialCsv {
  SerialCsv._();

  /// Encodes a list of rows into a csv string.
  static String encode(List<List<dynamic>> data) {
    return const SerialCsvEncoder().encode(data);
  }

  /// A specialized version of encode that encodes a list of rows of strings.
  static String encodeStrings(List<List<String>> data) {
    return const SerialCsvEncoder().encodeStrings(data);
  }

  /// A specialized version of encode that encodes a list of rows of integers.
  static String encodeIntegers(List<List<int>> data) {
    return const SerialCsvEncoder().encodeGeneric<int>(data);
  }

  /// A specialized version of encode that encodes a list of rows of doubles.
  static String encodeDoubles(List<List<double>> data) {
    return const SerialCsvEncoder().encodeGeneric<double>(data);
  }

  /// A specialized version of encode that encodes a list of rows of booleans.
  static String encodeBooleans(List<List<bool>> data) {
    return const SerialCsvEncoder().encodeGeneric<bool>(data);
  }

  /// Encodes a map of key-value pairs into a csv string.
  /// The encoded csv will have two columns.
  static String encodeMap(Map<String, dynamic> map) {
    return const SerialCsvEncoder().encodeMap(map);
  }

  /// Decodes a csv string into a list of rows.
  static List<List<dynamic>> decode(String csv) {
    return const SerialCsvDecoder().decode(csv);
  }

  /// A specialized version of decode that returns a list of rows of strings.
  static List<List<String>> decodeStrings(String csv) {
    return const SerialCsvDecoder().decode(csv).cast();
  }

  /// A specialized version of decode that returns a list of rows of integers.
  static List<List<int>> decodeIntegers(String csv) {
    return const SerialCsvDecoder().decodeIntegers(csv);
  }

  /// A specialized version of decode that returns a list of rows of doubles.
  static List<List<double>> decodeDoubles(String csv) {
    return const SerialCsvDecoder().decodeDoubles(csv);
  }

  /// A specialized version of decode that returns a list of rows of booleans.
  static List<List<bool>> decodeBooleans(String csv) {
    return const SerialCsvDecoder().decodeBooleans(csv);
  }

  /// Decodes a CSV consisting of key-value pairs into a map.
  /// The csv must have two columns and the first column must be a string.
  static Map<String, dynamic> decodeMap(String csv) {
    return const SerialCsvDecoder().decodeMap(csv);
  }
}
