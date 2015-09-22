# conspicio_fmt

A simple formatting library like those found in Java or .NET. Formatting for numbers and dates depends on the
NumberFormat and DateFormat classes from the intl library.

## Usage

The format function in the library takes two arguments, a format string and a List or a Map holding parameter values
to be using in the formatting of the string.

If parameters are provided as a List, the format string should hold numeric references to the list of parameters.  Each
formatting option is specified as an index, an optional width, and an optional formatting string enclosed in curly
brackets like:

* {0} - Inserts value of parameter 0.
* {1,12} - Insert value of parameter 1 right-justified in field that is 12 characters wide.
* {1,-12} - Inserts the value of parameter 1 left-justified in a field that is 12 characters wide.
* {2,12:#,###,##0.00} - Insert value of parameter 2 right-justified in a field that is 12 characters wide, formatted using
the pattern specified.
* {3:yyyy-MM-dd HH:mm:ss.SSS} - Insert value of parameter 3 formatted using the pattern specified.

Using a map to provide parameters allows for the use of keynames in the formatting option instead of the parameter index
used for lists.

* {name} - Inserts string value of the value with key = "name".
* {value, 12} - Inserts string value of the value with key = "value" right-justified in a field of width 12.
* {date-of-birth:yyyy-MM-dd} - Inserts the formatted date value of value with key = "date-of-birth".

Standard letters (\w), digits (\d), '-', and '_' are allowed as key values.

A simple usage example for List:

    import 'package:conspicio_fmt/fmt.dart' as fmt;

    main() {
      print(fmt.format("{0}={1}", ["My favorite number is", 21]));
      print(fmt.format(r"{0,-20}: {1,12:#,###,##0.00 \u00A4}", ["Tx. ref. 188726122", 129286.12]));
      print(fmt.format("{0:yyyy-MM-dd HH:mm:ss.SSS", [new DateTime.now()]}));
    }


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
