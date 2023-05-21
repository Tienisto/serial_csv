final _buffer = StringBuffer();

class SerialCsvEncoder {
  const SerialCsvEncoder();

  /// Encodes a list of rows into a csv string.
  String encode(List<List<dynamic>> csv) {
    for (final row in csv) {
      for (int i = 0; i < row.length; i++) {
        _buffer.write(_encodeCell(row[i]));

        if (i != row.length - 1) {
          _buffer.write(',');
        }
      }
      _buffer.write('\n');
    }
    final result = _buffer.toString();
    _buffer.clear();
    return result;
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

  /// Encodes a list of rows into a csv string.
  String encodeStringList(List<List<String>> csv) {
    for (final row in csv) {
      for (int i = 0; i < row.length; i++) {
        _buffer.write('"');
        _buffer.write(row[i].replaceAll('"', '""'));

        if (i != row.length - 1) {
          _buffer.write('",');
        } else {
          _buffer.write('"');
        }
      }
      _buffer.write('\n');
    }
    final result = _buffer.toString();
    _buffer.clear();
    return result;
  }

  /// Encodes a map into a csv string.
  String encodeMap(Map<String, dynamic> map) {
    for (final key in map.keys) {
      _buffer.write('"');
      _buffer.write(key.replaceAll('"', '""'));
      _buffer.write('",');
      _buffer.write(_encodeCell(map[key]));
      _buffer.write('\n');
    }
    final result = _buffer.toString();
    _buffer.clear();
    return result;
  }
}
