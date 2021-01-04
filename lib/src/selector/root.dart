import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class RootSelector with SelectorMixin implements Selector {
  const RootSelector();

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map((m) => JsonPathMatch(m.value, r'$'));

  @override
  dynamic set(dynamic json, Replacer replacement) => replacement(json);
}
