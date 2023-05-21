const _csvLineBreak = 10; // \n
const _csvQuote = 34; // "
const _csvComma = 44; // ,
const _codeUnitT = 116; // t
const _codeUnitF = 102; // f

class SerialCsvDecoder {
  const SerialCsvDecoder();

  /// Decodes a CSV string into a list of rows.
  List<List<dynamic>> decode(String data) {
    final List<List<Object?>> parsedData = [];

    List<Object?> currentRow = [];
    bool inQuotes = false;
    bool hadQuotes = false;
    final buffer = StringBuffer();

    for (int i = 0; i < data.length; i++) {
      int c = data.codeUnitAt(i);

      switch (c) {
        case _csvQuote:
          if (inQuotes) {
            if (i < data.length - 1 && data.codeUnitAt(i + 1) == _csvQuote) {
              // Escaped quote
              buffer.write('"');
              i++; // skip the second quote
            } else {
              // End of quoted field
              inQuotes = false;
              hadQuotes = true;
            }
          } else {
            // Start of quoted field
            inQuotes = true;
          }
          break;
        case _csvComma:
        case _csvLineBreak:
          // end of cell or row
          if (inQuotes) {
            buffer.writeCharCode(c);
          } else {
            currentRow.add(_decodeCell(buffer.toString(), hadQuotes));
            buffer.clear();
            hadQuotes = false;

            if (c == _csvLineBreak) {
              // End of the row
              parsedData.add(currentRow);
              currentRow = [];
            }
          }
          break;
        default:
          buffer.writeCharCode(c);
      }
    }

    return parsedData;
  }

  Object? _decodeCell(String raw, bool hadQuotes) {
    if (hadQuotes) {
      // a string
      return raw.replaceAll('""', '"');
    } else if (raw.isEmpty) {
      // a null value
      return null;
    } else if (raw.codeUnitAt(0) == _codeUnitT) {
      // a 'true' boolean
      return true;
    } else if (raw.codeUnitAt(0) == _codeUnitF) {
      // a 'false' boolean
      return false;
    } else if (raw.contains('.')) {
      // a double
      return double.parse(raw);
    } else {
      // an integer
      return int.parse(raw);
    }
  }

  /// Decodes a CSV string into a list of rows (specialized for strings).
  List<List<String>> decodeStringList(String data) {
    final List<List<String>> parsedData = [];

    List<String> currentRow = [];
    bool inQuotes = false;
    final buffer = StringBuffer();

    for (int i = 0; i < data.length; i++) {
      int c = data.codeUnitAt(i);

      switch (c) {
        case _csvQuote:
          if (inQuotes) {
            if (i < data.length - 1 && data.codeUnitAt(i + 1) == _csvQuote) {
              // Escaped quote
              buffer.write('"');
              i++; // skip the second quote
            } else {
              // End of quoted field
              inQuotes = false;
            }
          } else {
            // Start of quoted field
            inQuotes = true;
          }
          break;
        case _csvComma:
        case _csvLineBreak:
          // end of cell or row
          if (inQuotes) {
            buffer.writeCharCode(c);
          } else {
            currentRow.add(buffer.toString());
            buffer.clear();

            if (c == _csvLineBreak) {
              // End of the row
              parsedData.add(currentRow);
              currentRow = [];
            }
          }
          break;
        default:
          buffer.writeCharCode(c);
      }
    }

    return parsedData;
  }
}
