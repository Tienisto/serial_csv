import 'package:serial_csv/src/csv_decoder.dart';
import 'package:serial_csv/src/csv_encoder.dart';

class SerialCsv {
  SerialCsv._();

  /// Decodes a csv string into a list of rows.
  static List<List<dynamic>> decode(String csv) {
    return const SerialCsvDecoder().decode(csv);
  }

  /// Encodes a list of rows into a csv string.
  static String encode(List<List<Object?>> csv) {
    return const SerialCsvEncoder().encode(csv);
  }
}
