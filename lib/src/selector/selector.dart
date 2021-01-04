import 'package:json_path/src/json_path_match.dart';

/// Converts a set of matches into a set of matches
abstract class Selector {
  /// Applies this filter to the [matches]
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches);

  /// Combines this expression with the [other]
  Selector then(Selector other);

  /// Returns a copy of [json] with all selected values modified using [replacer] function.
  dynamic set(dynamic json, Replacer replacer);
}

typedef Replacer = dynamic Function(dynamic value);
