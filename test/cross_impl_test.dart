import 'dart:io';

import 'package:json_path/src/json_path.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  final doc = loadYaml(File('test/regression_suite.yaml').readAsStringSync());
  doc['queries'].forEach((e) {
    final id = e['id'];
    final selector = e['selector'].toString();
    final document = e['document'];
    final consensus = e['consensus'];
    final ordered = e['ordered'];
    String skip;
    if (consensus == 'NOT_SUPPORTED') {
      skip = 'Not Supported';
    }
    if (consensus == null) {
      skip = 'No consensus';
    }
    if (selector.contains('@')) {
      skip = 'Expression with "@"';
    }
    if (selector.contains('?')) {
      skip = 'Expression with "?"';
    }

    test('$id ($selector)', () {
      final jPath = JsonPath(selector);
      final result = jPath.read(document).map((e) => e.value).toList();
      if (consensus is List) {
        if (ordered == false) {
          expect(result, containsAll(consensus));
          expect(result.length, consensus.length);
        } else {
          expect(result, equals(consensus));
        }
      } else if (consensus == 'NOT_SUPPORTED') {
        expect(() => JsonPath(selector), throwsFormatException);
      }
    }, skip: skip);
  });
}
