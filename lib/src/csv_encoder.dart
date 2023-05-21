class SerialCsvEncoder {
  const SerialCsvEncoder();

  /// Encodes a list of rows into a csv string.
  String encode(List<List<dynamic>> csv) {
    final buffer = StringBuffer();
    for (final row in csv) {
      for (int i = 0; i < row.length; i++) {
        buffer.write(_encodeCell(row[i]));

        if (i != row.length - 1) {
          buffer.write(',');
        }
      }
      buffer.write('\n');
    }
    return buffer.toString();
  }

  /// Encodes a list of rows into a csv string.
  String encodeStringList(List<List<String>> csv) {
    final buffer = StringBuffer();
    for (final row in csv) {
      for (int i = 0; i < row.length; i++) {
        buffer.write('"');
        buffer.write(row[i].replaceAll('"', '""'));

        if (i != row.length - 1) {
          buffer.write('",');
        } else {
          buffer.write('"');
        }
      }
      buffer.write('\n');
    }
    return buffer.toString();
  }

  String _encodeCell(Object? cell) {
    if (cell == null) {
      return '';
    } else if (cell is String) {
      return '"${cell.replaceAll('"', '""')}"';
    } else {
      return cell.toString();
    }
  }
}
