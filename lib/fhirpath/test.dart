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
          json['name'].map((match) => match['given']).toList());
    });
    test('Single path with list', () {
      path = FhirPath('Patient.address.period.extension.extension.valueString');
      expect(path.read(json).map((match) => match.value).toList(), [
        'valueString1',
        'valueString2',
        'valueString3',
        'valueString4',
        'valueString5',
        'valueString6',
        'valueString7',
        'valueString8',
        'valueString9',
        'valueString10',
        'valueString11',
        'valueString12',
        'valueString13',
        'valueString14',
        'valueString15',
        'valueString16',
        'valueString17',
        'valueString18',
        'valueString19',
        'valueString20',
        'valueString21',
        'valueString22',
        'valueString23',
        'valueString24',
        'valueString25',
        'valueString26',
        'valueString27',
      ]);
    });
  });
}

var patient = Patient(
  address: [
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString1'),
              FhirExtension(valueString: 'valueString2'),
              FhirExtension(valueString: 'valueString3'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString4'),
              FhirExtension(valueString: 'valueString5'),
              FhirExtension(valueString: 'valueString6'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString7'),
              FhirExtension(valueString: 'valueString8'),
              FhirExtension(valueString: 'valueString9'),
            ],
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString10'),
              FhirExtension(valueString: 'valueString11'),
              FhirExtension(valueString: 'valueString12'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString13'),
              FhirExtension(valueString: 'valueString14'),
              FhirExtension(valueString: 'valueString15'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString16'),
              FhirExtension(valueString: 'valueString17'),
              FhirExtension(valueString: 'valueString18'),
            ],
          ),
        ],
      ),
    ),
    Address(
      period: Period(
        extension_: [
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString19'),
              FhirExtension(valueString: 'valueString20'),
              FhirExtension(valueString: 'valueString21'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString22'),
              FhirExtension(valueString: 'valueString23'),
              FhirExtension(valueString: 'valueString24'),
            ],
          ),
          FhirExtension(
            extension_: [
              FhirExtension(valueString: 'valueString25'),
              FhirExtension(valueString: 'valueString26'),
              FhirExtension(valueString: 'valueString27'),
            ],
          ),
        ],
      ),
    ),
  ],
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
