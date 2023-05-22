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
            // detect as string
            currentType = _DataType.string;
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
            inString = false;
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

  /// Decodes a CSV consisting of key-value pairs into a map.
  Map<String, dynamic> decodeMap(String data) {
    final bytes = data.codeUnits;
    final Map<String, dynamic> parsedData = {};

    int cursor = 0;

    row_loop:
    while (cursor != bytes.length) {
      // one iteration = one row

      String currentKey = '';

      // parse first column
      cursor++; // skip first quote
      int startString = cursor;
      List<int> doubleQuotes = [];
      while (true) {
        int char = bytes[cursor];

        if (char == _asciiQuote) {
          if (cursor + 1 < bytes.length && bytes[cursor + 1] == _asciiQuote) {
            doubleQuotes.add(cursor - startString);
            cursor += 2; // skip next quote
          } else {
            String value = data.substring(startString, cursor);
            for (final int doubleQuote in doubleQuotes.reversed) {
              value = value.replaceRange(doubleQuote, doubleQuote + 1, '');
            }
            currentKey = value;
            break; // found end quote
          }
        } else {
          cursor++;
        }
      }

      // skip end quote and comma
      cursor += 2;

      // detect type on first character
      int initialChar = bytes[cursor];
      switch (initialChar) {
        case _asciiQuote:
          // detected string
          cursor++; // skip first quote
          startString = cursor;
          doubleQuotes = [];
          while (true) {
            int char = bytes[cursor];

            if (char == _asciiQuote) {
              if (cursor + 1 < bytes.length &&
                  bytes[cursor + 1] == _asciiQuote) {
                doubleQuotes.add(cursor - startString);
                cursor += 2; // skip next quote
              } else {
                // found end quote
                String value = data.substring(startString, cursor);
                for (final int doubleQuote in doubleQuotes.reversed) {
                  value = value.replaceRange(doubleQuote, doubleQuote + 1, '');
                }
                parsedData[currentKey] = value;
                cursor += 2; // skip next line break
                continue row_loop;
              }
            } else {
              cursor++;
            }
          }
        case _asciiT:
        case _asciiF:
          // detected boolean
          parsedData[currentKey] = initialChar == _asciiT;

          // skip until linebreak
          while (true) {
            cursor++;
            if (bytes[cursor] == _asciiLineBreak) {
              cursor++;
              continue row_loop;
            }
          }
        case _asciiLineBreak:
          // detected null value
          parsedData[currentKey] = null;
          cursor++;
          continue row_loop;
        default:
          // number expected
          // assume as integer first, we change to double if we see a dot
          startString = cursor;

          integer_loop:
          while (true) {
            int char = bytes[cursor];

            switch (char) {
              case _asciiLineBreak:
                parsedData[currentKey] =
                    int.parse(data.substring(startString, cursor));
                cursor++;
                continue row_loop;
              case _asciiDot:
                cursor++;
                break integer_loop;
              default:
                cursor++;
            }
          }

          // double_loop
          while (true) {
            int char = bytes[cursor];

            if (char == _asciiLineBreak) {
              parsedData[currentKey] =
                  double.parse(data.substring(startString, cursor));
              cursor++;
              continue row_loop;
            }

            cursor++;
          }
      }
    }

    return parsedData;
  }
}
