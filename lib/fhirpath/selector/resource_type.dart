import 'package:fhir/r4.dart';

import '../child_match.dart';
import '../fhir_path_match.dart';
import '../selector.dart';

class ResourceType implements Selector {
  ResourceType(this.resourceType);

  final String resourceType;

  @override
  Iterable<FhirPathMatch> apply(FhirPathMatch match) sync* {
    final value = match.value;
    if (value is Map &&
        ResourceUtils.resourceTypeFromStringMap.keys.contains(resourceType) &&
        value.containsKey(resourceType)) {
      yield ChildMatch.child(resourceType, match);
    }
  }
}
