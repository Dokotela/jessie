import 'package:petitparser/petitparser.dart';

final integer =
    (char('-').optional() & digit().plus()).flatten().map(int.parse);

final decimal = (char('-').optional() &
        digit().plus() &
        (char('.') & digit().plus()).optional())
    .flatten()
    .map(double.parse);

/// ToDo
final date = digit().times(4) &
    (char('-') & ((char('0') & pattern('1-9')) | (char('1') & pattern('0-2'))))
        .optional();

/// ToDo
final dateTime = null;

/// ToDo
final Time = null;

/// ToDo
final quantity = null;
