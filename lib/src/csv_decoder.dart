const _csvLineBreak = 10; // \n
const _csvQuote = 34; // "
const _csvComma = 44; // ,

class SerialCsvDecoder {
  const SerialCsvDecoder();

  /// Decodes a CSV string into a list of rows.
  List<List<Object?>> decode(String data) {
    List<List<Object?>> parsedData = [];

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
          if (inQuotes) {
            buffer.writeCharCode(c);
          } else {
            // End of the cell
            currentRow.add(_decodeCell(buffer.toString(), hadQuotes));
            buffer.clear();
            hadQuotes = false;
          }
          break;
        case _csvLineBreak:
          if (inQuotes) {
            buffer.writeCharCode(c);
          } else {
            // End of the row
            currentRow.add(_decodeCell(buffer.toString(), hadQuotes));
            parsedData.add(currentRow);
            currentRow = [];
            buffer.clear();
            hadQuotes = false;
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
    } else if (raw == 'true') {
      // a boolean
      return true;
    } else if (raw == 'false') {
      // a boolean
      return false;
    } else if (raw.contains('.')) {
      // a double
      return double.parse(raw);
    } else {
      // an integer
      return int.parse(raw);
    }
  }
}
