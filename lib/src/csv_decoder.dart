const _asciiLineBreak = 10; // \n
const _asciiQuote = 34; // "
const _asciiComma = 44; // ,
const _asciiDot = 46; // .
const _asciiT = 116; // t
const _asciiF = 102; // f
const _ascii0 = 48; // 0
const _ascii1 = 49; // 1
const _ascii2 = 50; // 2
const _ascii3 = 51; // 3
const _ascii4 = 52; // 4
const _ascii5 = 53; // 5
const _ascii6 = 54; // 6
const _ascii7 = 55; // 7
const _ascii8 = 56; // 8
const _ascii9 = 57; // 9

enum _DataType {
  string,
  integer,
  double,
  boolean,
  nullValue,
}

class SerialCsvDecoder {
  const SerialCsvDecoder();

  /// Decodes a CSV string into a list of rows.
  List<List<dynamic>> decode(String data) {
    final bytes = data.codeUnits;
    final List<List<Object?>> parsedData = [];

    List<Object?> currentRow = [];
    _DataType currentType = _DataType.nullValue; // expect null if empty
    bool boolValue = false;
    bool finishedString = false;
    List<int> currentCell = [];

    for (int i = 0; i < bytes.length; i++) {
      int c = bytes[i];

      switch (c) {
        case _asciiQuote:
          if (currentType == _DataType.string) {
            if (i + 1 < bytes.length && bytes[i + 1] == _asciiQuote) {
              // Escaped quote
              currentCell.add(_asciiQuote);
              i++; // skip the second quote
            } else {
              // we are done with the string
              // expecting a comma or line break next
              finishedString = true;
            }
          } else {
            // detect as string
            currentType = _DataType.string;
          }
          break;
        case _asciiComma:
        case _asciiLineBreak:
          if (currentType == _DataType.string && !finishedString) {
            // we are still in the string
            currentCell.add(c);
          } else {
            // end of cell or row
            switch (currentType) {
              case _DataType.string:
                currentRow.add(String.fromCharCodes(currentCell));
                break;
              case _DataType.integer:
                currentRow.add(int.parse(String.fromCharCodes(currentCell)));
                break;
              case _DataType.double:
                currentRow.add(double.parse(String.fromCharCodes(currentCell)));
                break;
              case _DataType.boolean:
                currentRow.add(boolValue);
                break;
              case _DataType.nullValue:
                currentRow.add(null);
                break;
            }

            // reset cell
            currentCell = [];
            finishedString = false;
            currentType = _DataType.nullValue;

            if (c == _asciiLineBreak) {
              // end of the row
              parsedData.add(currentRow);

              // reset row
              currentRow = [];
            }
          }
          break;
        default:
          switch (currentType) {
            case _DataType.string:
              currentCell.add(c);
              break;
            case _DataType.integer:
              currentCell.add(c);
              if (c == _asciiDot) {
                // change to double
                currentType = _DataType.double;
              }
              break;
            case _DataType.double:
              currentCell.add(c);
              break;
            case _DataType.boolean:
              // we already detected the boolean value on the first character
              break;
            case _DataType.nullValue:
              // no type detected yet
              // detect type on first character
              switch (c) {
                case _asciiT:
                case _asciiF:
                  currentType = _DataType.boolean;
                  boolValue = c == _asciiT; // we are finished with the boolean
                  break;
                case _ascii0:
                case _ascii1:
                case _ascii2:
                case _ascii3:
                case _ascii4:
                case _ascii5:
                case _ascii6:
                case _ascii7:
                case _ascii8:
                case _ascii9:
                  // assume as integer first, we change to double if we see a dot
                  currentType = _DataType.integer;
                  currentCell.add(c);
                  break;
                default:
                  currentType = _DataType.string;
                  currentCell.add(c);
                  break;
              }
              break;
          }
      }
    }

    return parsedData;
  }

  /// Decodes a CSV string into a list of rows (specialized for strings).
  List<List<String>> decodeStringList(String data) {
    final bytes = data.codeUnits;
    final List<List<String>> parsedData = [];

    List<String> currentRow = [];
    bool inString = false;
    List<int> currentCell = [];

    for (int i = 0; i < bytes.length; i++) {
      int c = bytes[i];

      switch (c) {
        case _asciiQuote:
          if (inString) {
            if (i + 1 < bytes.length && bytes[i + 1] == _asciiQuote) {
              // Escaped quote
              currentCell.add(_asciiQuote);
              i++; // skip the second quote
            } else {
              // we are done with the string
              // expecting a comma or line break next
              inString = false;
            }
          } else {
            inString = true;
          }
          break;
        case _asciiComma:
        case _asciiLineBreak:
          if (inString) {
            // we are still in the string
            currentCell.add(c);
          } else {
            // end of cell or row
            currentRow.add(String.fromCharCodes(currentCell));

            // reset cell
            currentCell = [];
            inString = false;

            if (c == _asciiLineBreak) {
              // end of the row
              parsedData.add(currentRow);

              // reset row
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
}
