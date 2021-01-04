import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_mixin.dart';

class ListUnion with SelectorMixin implements Selector {
  ListUnion(List<int> keys)
      : _indices = keys.toList(),
        _indicesNormalized = keys.toSet().toList()..sort();

  final List<int> _indices;
  final List<int> _indicesNormalized;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) => matches
      .map((r) => (r.value is List) ? _map(r.value, r.path) : <JsonPathMatch>[])
      .expand((_) => _);

  @override
  dynamic set(dynamic json, Replacer replacement) {
    json ??= [];
    if (json is List) {
      json = [...json];
      _replaceInList(json, replacement);
    }
    return json;
  }

  Iterable<JsonPathMatch> _map(List list, String path) => _indices
      .map((key) => _normalize(list.length, key))
      .where((key) => key >= 0 && key < list.length)
      .map((key) => JsonPathMatch(list[key], path + '[$key]'));

  void _replaceInList(List list, Replacer replacement) =>
      _indicesNormalized.forEach((index) {
        if (index < list.length) {
          final n = _normalize(list.length, index);
          list[n] = replacement(list[n]);
        } else if (index == list.length) {
          list.add(replacement(null));
        } else {
          throw RangeError(
              'Can not set index $index. Preceding index is missing.');
        }
      });

  /// Normalizes negative index
  int _normalize(int length, int index) {
    if (index < 0) return length + index;
    return index;
  }
}
