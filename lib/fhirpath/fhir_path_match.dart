import 'package:rfc_6901/rfc_6901.dart';

import 'matching_context.dart';

/// A named filter function
typedef CallbackFilter = bool Function(FhirPathMatch match);

abstract class FhirPathMatch {
  /// The value
  dynamic get value;

  /// FHIRPath to this match
  String get path;

  /// FHIR Pointer (RFC 6901) to this match
  JsonPointer get pointer;

  /// Matching context
  MatchingContext get context;

  /// The parent match
  FhirPathMatch? get parent;
}
