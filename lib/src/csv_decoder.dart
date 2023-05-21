const _asciiLineBreak = 10; // \n
const _asciiQuote = 34; // "
const _asciiComma = 44; // ,
const _asciiT = 116; // t
const _asciiF = 102; // f

class SerialCsvDecoder {
  const SerialCsvDecoder();

  /// Decodes a CSV string into a list of rows.
  List<List<dynamic>> decode(String data) {
    final bytes = data.codeUnits;
    final List<List<Object?>> parsedData = [];

    List<Object?> currentRow = [];
    bool inQuotes = false;
    bool hadQuotes = false;
    List<int> currentCell = [];

    for (int i = 0; i < bytes.length; i++) {
      int c = bytes[i];

      switch (c) {
        case _asciiQuote:
          if (inQuotes) {
            if (i + 1 < bytes.length && bytes[i + 1] == _asciiQuote) {
              // Escaped quote
              currentCell.add(_asciiQuote);
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
        case _asciiComma:
        case _asciiLineBreak:
          // end of cell or row
          if (inQuotes) {
            currentCell.add(c);
          } else {
            currentRow.add(
              _decodeCell(String.fromCharCodes(currentCell), hadQuotes),
            );
            currentCell = [];
            hadQuotes = false;

            if (c == _asciiLineBreak) {
              // End of the row
              parsedData.add(currentRow);
              currentRow = [];
            }
          }
          break;
        default:
          currentCell.add(c);
      }
    }

    return parsedData;
  }

  Object? _decodeCell(String raw, bool hadQuotes) {
    if (hadQuotes) {
      // a string
      return raw;
    } else if (raw.isEmpty) {
      // a null value
      return null;
    } else if (raw.codeUnitAt(0) == _asciiT) {
      // a 'true' boolean
      return true;
    } else if (raw.codeUnitAt(0) == _asciiF) {
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
        case _asciiQuote:
          if (inQuotes) {
            if (i < data.length - 1 && data.codeUnitAt(i + 1) == _asciiQuote) {
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
        case _asciiComma:
        case _asciiLineBreak:
          // end of cell or row
          if (inQuotes) {
            buffer.writeCharCode(c);
          } else {
            currentRow.add(buffer.toString());
            buffer.clear();

            if (c == _asciiLineBreak) {
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
