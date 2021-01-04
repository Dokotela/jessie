import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/quote.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Wildcard with SelectorMixin implements Selector {
  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map((r) {
        if (r.value is Map) return _allProperties(r.value, r.path);
        if (r.value is List) return _allValues(r.value, r.path);
        return <JsonPathMatch>[];
      }).expand((_) => _);

  Iterable<JsonPathMatch> _allProperties(Map map, String path) => map.entries
      .map((e) => JsonPathMatch(e.value, path + '[${SingleQuote(e.key)}]'));

  Iterable<JsonPathMatch> _allValues(List list, String path) => list
      .asMap()
      .entries
      .map((e) => JsonPathMatch(e.value, path + '[${e.key}]'));

  @override
  dynamic set(dynamic json, Replacer replacement) {
    if (json is Map) {
      return json.map((key, value) => MapEntry(key, replacement(value)));
    }
    if (json is List) {
      return json.map(replacement).toList();
    }
    return json;
  }
}
