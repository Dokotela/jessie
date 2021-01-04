import 'package:json_path/src/ast/ast.dart';
import 'package:json_path/src/ast/node.dart';
import 'package:json_path/src/ast/tokenize.dart';
import 'package:json_path/src/predicate.dart';
import 'package:json_path/src/selector/filter.dart';
import 'package:json_path/src/selector/list_union.dart';
import 'package:json_path/src/selector/object_union.dart';
import 'package:json_path/src/selector/recursive.dart';
import 'package:json_path/src/selector/root.dart';
import 'package:json_path/src/selector/selector.dart';
import 'package:json_path/src/selector/slice.dart';
import 'package:json_path/src/selector/wildcard.dart';

class Parser {
  const Parser();

  Selector parse(String expression, Map<String, Predicate> filter) {
    if (expression.isEmpty) throw FormatException('Empty expression');
    _State state = _Ready(const RootSelector());
    AST(tokenize(expression)).nodes.forEach((node) {
      state = state.process(node, filter ?? {});
    });
    return state.selector;
  }
}

/// AST parser state
abstract class _State {
  /// Processes the node. Returns the next state
  _State process(Node node, Map<String, Predicate> filters);

  /// Selector made from the tree
  Selector get selector;
}

/// Ready to process the next node
class _Ready implements _State {
  _Ready(this.selector);

  @override
  final Selector selector;

  @override
  _State process(Node node, Map<String, Predicate> filters) {
    switch (node.value) {
      case '[':
        return _Ready(selector.followedBy(_brackets(node.children, filters)));
      case '.':
        return _Awaiting(selector);
      case '..':
        return _Ready(selector.followedBy(Recursive()));
      case '*':
        return _Ready(selector.followedBy(Wildcard()));
      default:
        return _Ready(selector.followedBy(ObjectUnion([node.value])));
    }
  }

  Selector _brackets(List<Node> nodes, Map<String, Predicate> filters) {
    if (nodes.isEmpty) throw FormatException('Empty brackets');
    if (nodes.length == 1 && nodes.single.value != ':') {
      return _singleValueBrackets(nodes.single);
    }
    return _multiValueBrackets(nodes, filters);
  }

  Selector _singleValueBrackets(Node node) {
    if (node.isWildcard) return Wildcard();
    if (node.isNumber) return ListUnion([node.intValue]);
    if (node.isQuoted) return ObjectUnion([node.unquoted]);
    throw FormatException('Unexpected bracket expression');
  }

  Selector _multiValueBrackets(
      List<Node> nodes, Map<String, Predicate> filters) {
    if (_isFilter(nodes)) return _filter(nodes, filters);
    if (_isSlice(nodes)) return _slice(nodes);
    return _union(nodes);
  }

  Filter _filter(List<Node> nodes, Map<String, Predicate> filters) {
    final name = nodes[1].value;
    if (!filters.containsKey(name)) {
      throw FormatException('Filter not found: "${name}"');
    }
    return Filter(name, filters[name]);
  }

  bool _isFilter(List<Node> nodes) => nodes.first.value == '?';

  bool _isSlice(List<Node> nodes) => nodes.any((node) => node.value == ':');

  Selector _union(List<Node> nodes) {
    final filtered = nodes.where((_) => _.value != ',');
    if (filtered.every((_) => _.isNumber)) {
      return ListUnion(filtered.map((_) => _.intValue).toList());
    }
    return ObjectUnion(
        filtered.map((_) => _.isQuoted ? _.unquoted : _.value).toList());
  }

  Slice _slice(List<Node> nodes) {
    int first;
    int last;
    int step;
    var colons = 0;
    nodes.forEach((node) {
      if (node.value == ':') {
        colons++;
        return;
      }
      if (colons == 0) {
        first = node.intValue;
        return;
      }
      if (colons == 1) {
        last = node.intValue;
        return;
      }
      step = node.intValue;
    });
    return Slice(first: first, last: last, step: step);
  }
}

class _Awaiting implements _State {
  _Awaiting(this.selector);

  @override
  final Selector selector;

  @override
  _State process(Node node, Map<String, Predicate> filters) {
    if (node.isWildcard) {
      return _Ready(selector.followedBy(Wildcard()));
    }
    return _Ready(selector.followedBy(ObjectUnion([node.value])));
  }
}
