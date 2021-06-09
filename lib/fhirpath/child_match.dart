import 'package:rfc_6901/rfc_6901.dart';

import 'fhir_path_match.dart';
import 'matching_context.dart';
import 'quote.dart';

/// Creates a match for a child element
class ChildMatch implements FhirPathMatch {
  /// Child match for an array element
  ChildMatch.index(int index, this.parent)
      : value = parent.value[index],
        path = parent.path + '[' + index.toString() + ']',
        pointer = JsonPointerSegment(index.toString(), parent.pointer);

  /// Child match for an object child
  ChildMatch.child(String key, this.parent)
      : value = parent.value[key],
        path = parent.path + '[' + quote(key) + ']',
        pointer = JsonPointerSegment(key, parent.pointer);

  /// Child match for an object child
  ChildMatch.childList(String key, this.parent)
      : value = parent.value.map((v) => v[key]).toList(),
        path = parent.path + '[' + quote(key) + ']',
        pointer = JsonPointerSegment(key, parent.pointer);

  /// The value
  @override
  final value;

  /// FHIRPath to this match
  @override
  final String path;

  /// FHIR Pointer (RFC 6901) to this match
  @override
  final JsonPointer pointer;

  @override
  MatchingContext get context => parent.context;

  @override
  final FhirPathMatch parent;
}
