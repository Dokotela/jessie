import '../fhir_path_match.dart';
import '../selector.dart';

class Sequence implements Selector {
  Sequence(Iterable<Selector> selectors)
      : _filter = selectors.fold<_Filter>(
            (_) => _,
            (filter, selector) => (matches) =>
                filter(matches).map(selector.apply).expand((_) => _));

  final _Filter _filter;

  @override
  Iterable<FhirPathMatch> apply(FhirPathMatch match) => _filter([match]);
}

typedef _Filter = Iterable<FhirPathMatch> Function(
    Iterable<FhirPathMatch> matches);
