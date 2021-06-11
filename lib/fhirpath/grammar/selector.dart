import 'package:petitparser/petitparser.dart';

import '../selector/field.dart';
import 'strings.dart';

final fieldName = dotString.map((value) => Field(value));

final dotMatcher = (char('.') & fieldName).map((value) => value.last);

final selector = fieldName | dotMatcher;
