class Node {
  Node(this.value);

  final String value;
  final children = <Node>[];

  bool get isNumber => RegExp(r'^-?\d+$').hasMatch(value);

  bool get isQuoted =>
      value.length > 1 &&
      ((value.startsWith("'") && value.endsWith("'")) ||
          (value.startsWith('"') && value.endsWith('"')));

  bool get isWildcard => value == '*';

  String get unquoted => value
      .substring(1, value.length - 1)
      .replaceAll(r'\\', r'\')
      .replaceAll(r"\'", r"'")
      .replaceAll(r'\"', r'"');

  int get intValue => int.parse(value);
}
