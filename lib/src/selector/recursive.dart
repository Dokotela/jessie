import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/quote.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class Recursive with SelectorMixin implements Selector {
  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      matches.map(_traverse).expand((_) => _);

  @override
  dynamic set(dynamic json, Replacer replacement) {
    if (json is Map) {
      return _replaceInMap(json, replacement);
    }
    if (json is List) {
      return _replaceInList(json, replacement);
    }
    return replacement(json);
  }

  Iterable<JsonPathMatch> _traverse(JsonPathMatch m) {
    if (m.value is Map) {
      return [m].followedBy(read(_props(m.value, m.path)));
    }
    if (m.value is List) {
      return [m].followedBy(read(_values(m.value, m.path)));
    }
    return <JsonPathMatch>[];
  }

  dynamic _replaceInMap(Map map, Replacer replacement) => replacement(
      map.map((key, value) => MapEntry(key, set(value, replacement))));

  dynamic _replaceInList(List list, Replacer replacement) =>
      replacement(list.map((value) => set(value, replacement)).toList());

  Iterable<JsonPathMatch> _values(List val, String path) => val
      .asMap()
      .entries
      .map((e) => JsonPathMatch(e.value, path + '[${e.key}]'));

  Iterable<JsonPathMatch> _props(Map map, String path) => map.entries
      .map((e) => JsonPathMatch(e.value, path + '[${SingleQuote(e.key)}]'));
}
