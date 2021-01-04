import 'package:json_path/json_path.dart';
import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_base.dart';

class Filter extends SelectorBase {
  const Filter(this.name, this.isApplicable);

  final String name;

  final Predicate isApplicable;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.where((r) => isApplicable(r.value));

  @override
  dynamic set(dynamic json, Replacer replacement) =>
      isApplicable(json) ? replacement(json) : json;
}
