import 'package:petitparser/petitparser.dart';

import '../selector/field.dart';
import '../selector/resource_type.dart';

final word = letter().plus().flatten();

final resourceRoot =
    letter().plus().flatten().map((value) => ResourceType(value));

final dotString =
    (anyOf('-_') | letter() | digit() | range(0x80, 0x10FFF)).plus().flatten();

final fieldName = dotString.map((value) => Field(value));

final dotMatcher = (char('.') & fieldName).map((value) => value.last);

final selector = fieldName | dotMatcher;
