import 'package:serial_csv/src/csv_decoder.dart';
import 'package:serial_csv/src/csv_encoder.dart';

class SerialCsv {
  SerialCsv._();

  /// Decodes a csv string into a list of rows.
  static List<List<dynamic>> decode(String csv) {
    return const SerialCsvDecoder().decode(csv);
  }

  /// A specialized version of decode that returns a list of rows of strings.
  static List<List<String>> decodeStringList(String csv) {
    return const SerialCsvDecoder().decodeStringList(csv);
  }

  /// Encodes a list of rows into a csv string.
  static String encode(List<List<dynamic>> csv) {
    return const SerialCsvEncoder().encode(csv);
  }

  /// A specialized version of encode that encodes a list of rows of strings.
  static String encodeStringList(List<List<String>> csv) {
    return const SerialCsvEncoder().encodeStringList(csv);
  }
}
