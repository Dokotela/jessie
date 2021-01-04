Iterable<String> tokenize(String expr) =>
    _tokens.allMatches(expr).map((match) => match.group(0));

final _tokens = RegExp(
    [
      r'\$', // root
      r'\[', // left bracket
      r'\]', // right bracket
      r'\.\.', // recursion
      r'\.', // child
      r'\*', // wildcard
      r':', // slice
      r',', // union
      r'\?', // filter
      r"'(?:[^'\\]|\\.)*'", // single quoted string
      r'"(?:[^"\\]|\\.)*"', // double quoted string
      r'-?\d+', // integer
      r'([\p{Letter}_-][\p{Letter}_\d-]*)', // field
    ].join('|'),
    unicode: true);
