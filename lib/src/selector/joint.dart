import 'package:json_path/src/json_path_match.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/selector_base.dart';

/// A combination of two adjacent selectors
class Joint extends SelectorBase {
  const Joint(this.left, this.right);

  /// Rightmost leaf in the tree
  static Selector rightmost(Selector s) => s is Joint ? rightmost(s.right) : s;

  /// Leftmost leaf in the tree
  static Selector leftmost(Selector s) => s is Joint ? leftmost(s.left) : s;

  /// Left subtree
  final Selector left;

  /// Right subtree
  final Selector right;

  @override
  Iterable<JsonPathMatch> read(Iterable<JsonPathMatch> matches) =>
      right.read(left.read(matches));

  @override
  dynamic set(dynamic json, Replacer replacement) =>
      left.set(json, (_) => right.set(_, replacement));
}
