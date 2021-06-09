import 'package:petitparser/core.dart';
import 'package:petitparser/petitparser.dart';

import 'fhir_path_match.dart';
import 'grammar/fhir_path.dart';
import 'root_match.dart';
import 'selector.dart';

/// A FHIRPath expression
class FhirPath {
  /// Creates an instance from string. The [expression] is parsed once, and
  /// the instance may be used many times after that.
  ///
  /// Throws [FormatException] if the [expression] can not be parsed.
  FhirPath(this.expression, {this.filters = const {}})
      : selector = _parse(expression);

  static Selector _parse(String expression) {
    try {
      return fhirPath.parse(expression).value;
    } on ParserException catch (e) {
      throw FormatException('$e. Expression: ${e.source}');
    }
  }

  /// FHIRPath expression.
  final String expression;
  final Selector selector;

  /// Named callback filters
  final Map<String, CallbackFilter> filters;

  /// Reads the given [document] object returning an Iterable of all matches found.
  Iterable<FhirPathMatch> read(document,
          {Map<String, CallbackFilter> filters = const {}}) =>
      selector.apply(RootMatch(document, {...this.filters, ...filters}));

  /// Reads the given [json] object returning an Iterable of all values found.
  Iterable readValues(json) => read(json).map((_) => _.value);

  @override
  String toString() => expression;
}
