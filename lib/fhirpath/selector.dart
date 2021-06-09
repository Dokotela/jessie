import 'fhir_path_match.dart';

abstract class Selector {
  /// Applies the selector to the [match]
  Iterable<FhirPathMatch> apply(FhirPathMatch match);
}
