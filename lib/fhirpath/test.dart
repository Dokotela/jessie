import 'package:fhir/r4.dart';
import 'package:test/test.dart';

import 'fhir_path.dart';

void main() {
  var path;
  var json = patient.toJson();
  group('Basic path selection', () {
    test('Single path', () {
      path = FhirPath('Patient.name');
      expect(
          path.read(json).map((match) => match.value).toList(), [json['name']]);
    });
    test('Single path with list', () {
      path = FhirPath('Patient.name.given');
      expect(path.read(json).map((match) => match.value).toList(),
          [json['name'].map((match) => match['given']).toList()]);
    });
  });
}

var patient = Patient(
  deceasedBoolean: Boolean('false'),
  name: [
    HumanName(
      family: 'Smith',
      given: ['John'],
    ),
    HumanName(
      family: 'Smith',
      given: ['John', 'Jacob'],
    ),
    HumanName(
      family: 'Smith',
      given: ['John', 'Jacob', 'Jingleheimer'],
    ),
  ],
);
