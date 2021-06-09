import '../selector/resource_type.dart';
import 'package:petitparser/petitparser.dart';

import '../selector.dart';
import '../selector/sequence.dart';
import 'selector.dart';

final fhirPath = (letter()
            .plus()
            .flatten()
            .map((value) => ResourceType(value))
            .star() &
        selector.plus())
    .end()
    .map((value) => Sequence((value.last as List).map((e) => e as Selector)));
