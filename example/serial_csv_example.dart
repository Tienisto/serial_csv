import 'package:serial_csv/serial_csv.dart';

void main() {
  const csv = '"a","b","c"\n1,2.3,"3"\n4,,true\n';
  List<List<dynamic>> decoded = SerialCsv.decode(csv);
  String encoded = SerialCsv.encode(decoded);

  for (int row = 0; row < decoded.length; row++) {
    for (int col = 0; col < decoded[row].length; col++) {
      print('decoded[$row][$col]: ${decoded[row][col]} (${decoded[row][col].runtimeType})');
    }
  }

  print('encoded:');
  print(encoded);
}
