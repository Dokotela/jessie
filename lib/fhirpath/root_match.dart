import 'package:rfc_6901/rfc_6901.dart';

import 'fhir_path_match.dart';
import 'matching_context.dart';

/// Creates a match for the root element
class RootMatch implements FhirPathMatch {
  RootMatch(this.value, Map<String, CallbackFilter> filters)
      : context = MatchingContext(filters),
        path = value['resourceType'];

  @override
  final MatchingContext context;

  @override
  final parent = null;

  @override
  final path;

  @override
  final pointer = JsonPointer();

  @override
  final value;
}
