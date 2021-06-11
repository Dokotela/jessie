import '../child_match.dart';
import '../fhir_path_match.dart';
import '../selector.dart';

class Field implements Selector {
  Field(this.name);

  final String name;

  @override
  Iterable<FhirPathMatch> apply(FhirPathMatch match) sync* {
    final value = match.value;
    if (value is Map && value.containsKey(name)) {
      yield ChildMatch.child(name, match);
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        yield ChildMatch.child(name, ChildMatch.index(i, match));
      }
    }
  }
}
