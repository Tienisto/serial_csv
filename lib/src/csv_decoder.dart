const _asciiLineBreak = 10; // \n
const _asciiQuote = 34; // "
const _asciiComma = 44; // ,
const _asciiDot = 46; // .
const _asciiT = 116; // t
const _asciiF = 102; // f

const _trueLength = 4;
const _falseLength = 5;

/// Decoding algorithms to parse CSV to List or Map.
///
/// Optimizations should be made first in [decode] when possible
/// because [decodeIntegers], [decodeDoubles], [decodeBooleans]
/// are based on [decode] with unused code removed.
class SerialCsvDecoder {
  const SerialCsvDecoder();

  /// Decodes a CSV string into a list of rows.
  List<List<dynamic>> decode(String data) {
    final bytes = data.codeUnits;
    final List<List<Object?>> parsedData = [];

    int cursor = 0;

    row_loop:
    while (cursor != bytes.length) {
      // one iteration represents one row

      List<Object?> currentRow = [];

      cell_loop:
      while (true) {
        // one iteration represents one cell

        int initialChar = bytes[cursor];

        if (currentRow.isNotEmpty) {
          switch (initialChar) {
            case _asciiComma:
              // next cell
              initialChar = bytes[++cursor];
              break;
            case _asciiLineBreak:
              // end of row
              parsedData.add(currentRow);
              cursor++;
              continue row_loop;
          }
        }

        switch (initialChar) {
          case _asciiQuote:
            // detected string
            cursor++; // skip first quote
            int startString = cursor;
            List<int> doubleQuotes = [];
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
                    value =
                        value.replaceRange(doubleQuote, doubleQuote + 1, '');
                  }
                  currentRow.add(value);
                  cursor++;
                  continue cell_loop;
                }
              } else {
                cursor++;
              }
            }
          case _asciiT:
          case _asciiF:
            // detected boolean
            final boolValue = initialChar == _asciiT;
            currentRow.add(boolValue);

            // skip until linebreak or comma
            if (boolValue) {
              cursor += _trueLength;
            } else {
              cursor += _falseLength;
            }

            continue cell_loop;
          case _asciiComma:
          case _asciiLineBreak:
            // detected null value
            currentRow.add(null);
            continue cell_loop;
          default:
            // number expected
            // assume as integer first, we change to double if we see a dot
            int startString = cursor;

            integer_loop:
            while (true) {
              int char = bytes[cursor];

              switch (char) {
                case _asciiComma:
                case _asciiLineBreak:
                  currentRow
                      .add(int.parse(data.substring(startString, cursor)));
                  continue cell_loop;
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

              if (char == _asciiComma || char == _asciiLineBreak) {
                currentRow
                    .add(double.parse(data.substring(startString, cursor)));
                continue cell_loop;
              }

              cursor++;
            }
        }
      }
    }

    return parsedData;
  }

  List<List<int>> decodeIntegers(String data) {
    final bytes = data.codeUnits;
    final List<List<int>> parsedData = [];

    int cursor = 0;

    row_loop:
    while (cursor != bytes.length) {
      // one iteration represents one row

      List<int> currentRow = [];

      cell_loop:
      while (true) {
        // one iteration represents one cell

        int initialChar = bytes[cursor];

        if (currentRow.isNotEmpty) {
          switch (initialChar) {
            case _asciiComma:
              // next cell
              initialChar = bytes[++cursor];
              break;
            case _asciiLineBreak:
              // end of row
              parsedData.add(currentRow);
              cursor++;
              continue row_loop;
          }
        }

        int startString = cursor;

        while (true) {
          int char = bytes[cursor];

          switch (char) {
            case _asciiComma:
            case _asciiLineBreak:
              currentRow.add(int.parse(data.substring(startString, cursor)));
              continue cell_loop;
            default:
              cursor++;
          }
        }
      }
    }

    return parsedData;
  }

  List<List<double>> decodeDoubles(String data) {
    final bytes = data.codeUnits;
    final List<List<double>> parsedData = [];

    int cursor = 0;

    row_loop:
    while (cursor != bytes.length) {
      // one iteration represents one row

      List<double> currentRow = [];

      cell_loop:
      while (true) {
        // one iteration represents one cell

        int startString = cursor;

        while (true) {
          int char = bytes[cursor];

          if (char == _asciiComma) {
            currentRow.add(double.parse(data.substring(startString, cursor)));
            cursor++;
            continue cell_loop;
          }

          if (char == _asciiLineBreak) {
            currentRow.add(double.parse(data.substring(startString, cursor)));
            // end of row
            parsedData.add(currentRow);
            cursor++;
            continue row_loop;
          }

          cursor++;
        }
      }
    }

    return parsedData;
  }

  List<List<bool>> decodeBooleans(String data) {
    final bytes = data.codeUnits;
    final List<List<bool>> parsedData = [];

    int cursor = 0;

    row_loop:
    while (cursor != bytes.length) {
      // one iteration represents one row

      List<bool> currentRow = [];

      cell_loop:
      while (true) {
        // one iteration represents one cell

        int initialChar = bytes[cursor];

        if (currentRow.isNotEmpty) {
          switch (initialChar) {
            case _asciiComma:
              // next cell
              initialChar = bytes[++cursor];
              break;
            case _asciiLineBreak:
              // end of row
              parsedData.add(currentRow);
              cursor++;
              continue row_loop;
          }
        }

        final boolValue = initialChar == _asciiT;
        currentRow.add(boolValue);

        // skip until linebreak or comma
        if (boolValue) {
          cursor += _trueLength;
        } else {
          cursor += _falseLength;
        }

        continue cell_loop;
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
      // one iteration represents one row

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
          final boolValue = initialChar == _asciiT;
          parsedData[currentKey] = boolValue;

          // skip until linebreak
          if (boolValue) {
            cursor += _trueLength;
          } else {
            cursor += _falseLength;
          }
          cursor++; // skip line break
          continue row_loop;
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
