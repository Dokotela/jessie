import 'dart:convert';
import 'dart:io';

import 'package:json_path/json_path.dart';
import 'package:test/test.dart';

void main() {
  final json = jsonDecode(File('test/store.json').readAsStringSync());
  group('Basic expressions', () {
    test('Only root', () {
      final root = JsonPath(r'$');
      expect(root.toString(), r'$');
      expect(root.read(json).single.value, json);
      expect(root.read(json).single.path, r'$');
    });

    test('Single field', () {
      final store = JsonPath(r'$.store');
      expect(store.read(json).single.value, json['store']);
      expect(store.read(json).single.path, r"$['store']");
    });

    test('Single field with digits', () {
      final j = {'aA_12': 'foo'};
      final store = JsonPath(r'$aA_12');
      expect(store.read(j).single.value, 'foo');
      expect(store.read(j).single.path, r"$['aA_12']");
    });

    test('Single-quoted field in bracket notation', () {
      final store = JsonPath(r"$['store']");
      expect(store.read(json).single.value, json['store']);
      expect(store.read(json).single.path, r"$['store']");
    });

    test('Double-quoted field in bracket notation', () {
      final store = JsonPath(r'$["store"]');
      expect(store.read(json).single.value, json['store']);
      expect(store.read(json).single.path, r"$['store']");
    });

    test('Mixed brackets and fields', () {
      final price = JsonPath("\$['store'].bicycle[\"price\"]");
      expect(price.read(json).single.value, json['store']['bicycle']['price']);
      expect(price.read(json).single.path, r"$['store']['bicycle']['price']");
    });
    test('Empty string key', () {
      final emptySingle = JsonPath("\$['']");
      final emptyDouble = JsonPath('\$[""]');
      final data = {'': 42, "''": 123, '""': 222};
      expect(emptySingle.read(data).single.value, 42);
      expect(emptyDouble.read(data).single.value, 42);
    });
  });

  group('Invalid format', () {
    test('Empty', () {
      expect(() => JsonPath(''), throwsFormatException);
    });
  });

  group('Slices', () {
    final abc = 'abcdefg'.split('');
    test('1:3', () {
      final slice = JsonPath(r'$[1:3]');
      expect(slice.read(abc).length, 2);
      expect(slice.read(abc).first.value, 'b');
      expect(slice.read(abc).first.path, r'$[1]');
      expect(slice.read(abc).last.value, 'c');
      expect(slice.read(abc).last.path, r'$[2]');
    });
    test('1:5:2', () {
      final slice = JsonPath(r'$[1:5:2]');
      expect(slice.read(abc).length, 2);
      expect(slice.read(abc).first.value, 'b');
      expect(slice.read(abc).first.path, r'$[1]');
      expect(slice.read(abc).last.value, 'd');
      expect(slice.read(abc).last.path, r'$[3]');
    });
    test('1:5:-2', () {
      final slice = JsonPath(r'$[1:5:-2]');
      expect(slice.read(abc).length, 0);
    });
    test(':3', () {
      final slice = JsonPath(r'$[:3]');
      expect(slice.read(abc).length, 3);
      expect(slice.read(abc).first.value, 'a');
      expect(slice.read(abc).first.path, r'$[0]');
      expect(slice.read(abc).last.value, 'c');
      expect(slice.read(abc).last.path, r'$[2]');
    });
    test(':3:2', () {
      final slice = JsonPath(r'$[:3:2]');
      expect(slice.read(abc).length, 2);
      expect(slice.read(abc).first.value, 'a');
      expect(slice.read(abc).first.path, r'$[0]');
      expect(slice.read(abc).last.value, 'c');
      expect(slice.read(abc).last.path, r'$[2]');
    });
    test('3::2', () {
      final slice = JsonPath(r'$[3::2]');
      expect(slice.read(abc).length, 2);
      expect(slice.read(abc).first.value, 'd');
      expect(slice.read(abc).first.path, r'$[3]');
      expect(slice.read(abc).last.value, 'f');
      expect(slice.read(abc).last.path, r'$[5]');
    });
    test('100:', () {
      final slice = JsonPath(r'$[100:]');
      expect(slice.read(abc).length, 0);
    });
    test('3:', () {
      final slice = JsonPath(r'$[3:]');
      expect(slice.read(abc).length, 4);
      expect(slice.read(abc).first.value, 'd');
      expect(slice.read(abc).first.path, r'$[3]');
      expect(slice.read(abc).last.value, 'g');
      expect(slice.read(abc).last.path, r'$[6]');
    });
    test(':-5', () {
      final slice = JsonPath(r'$[:-5]');
      expect(slice.read(abc).length, 2);
      expect(slice.read(abc).first.value, 'a');
      expect(slice.read(abc).first.path, r'$[0]');
      expect(slice.read(abc).last.value, 'b');
      expect(slice.read(abc).last.path, r'$[1]');
    });

    test('-5:', () {
      final slice = JsonPath(r'$[-5:]');
      expect(slice.read(abc).length, 5);
      expect(slice.read(abc).first.value, 'c');
      expect(slice.read(abc).first.path, r'$[2]');
      expect(slice.read(abc).last.value, 'g');
      expect(slice.read(abc).last.path, r'$[6]');
    });
    test('-1', () {
      final slice = JsonPath(r'$[-1]');
      expect(slice.read(['one', 'two', 'three']).length, 1);
      expect(slice.read(['one', 'two', 'three']).single.value, 'three');
      expect(slice.read(['one', 'two', 'three']).single.path, r'$[2]');
    });
    test('0:6', () {
      final slice = JsonPath(r'$[0:6]');
      expect(slice.read(abc).length, 6);
      expect(slice.read(abc).first.value, 'a');
      expect(slice.read(abc).first.path, r'$[0]');
      expect(slice.read(abc).last.value, 'f');
      expect(slice.read(abc).last.path, r'$[5]');
    });
    test('0:100', () {
      final slice = JsonPath(r'$[0:100]');
      expect(slice.read(abc).length, 7);
      expect(slice.read(abc).first.value, 'a');
      expect(slice.read(abc).first.path, r'$[0]');
      expect(slice.read(abc).last.value, 'g');
      expect(slice.read(abc).last.path, r'$[6]');
    });
    test('-6:-1', () {
      final slice = JsonPath(r'$[-6:-1]');
      expect(slice.read(abc).length, 5);
      expect(slice.read(abc).first.value, 'b');
      expect(slice.read(abc).first.path, r'$[1]');
      expect(slice.read(abc).last.value, 'f');
      expect(slice.read(abc).last.path, r'$[5]');
    });
    test(':', () {
      final slice = JsonPath(r'$[:]');
      final data = ['first', 'second'];
      expect(slice.read(data).length, 2);
      expect(slice.read(data).first.value, 'first');
      expect(slice.read(data).last.value, 'second');
    });
    test('..[0]', () {
      final slice = JsonPath(r'$..[0]');
      final data = [
        'first',
        {
          'key': [
            'first nested',
            {
              'more': [
                {
                  'nested': ['deepest', 'second']
                },
                ['more', 'values']
              ]
            }
          ]
        }
      ];
      expect(slice.read(data).length, 5);
    });
  });

  group('Uncommon brackets', () {
    test('Escape single quote', () {
      final j = {r"sq'sq s\s " '"' r"qs\'qs": 'value'};
      final path = JsonPath(r"$['sq\'sq s\\s " '"' r"qs\\\'qs']");
      final select = path.read(j);
      expect(select.single.value, 'value');
      expect(select.single.path, r"$['sq\'sq s\\s " '"' r"qs\\\'qs']");
    });
  });

  group('Union', () {
    test('List', () {
      final abc = 'abcdefg'.split('');
      final union = JsonPath(r'$[5,3,100,,2,]');
      expect(union.read(abc).length, 3);
      expect(union.read(abc).first.value, 'f');
      expect(union.read(abc).first.path, r'$[5]');
      expect(union.read(abc).last.value, 'c');
      expect(union.read(abc).last.path, r'$[2]');
    });
    test('Numerical object key', () {
      final first = JsonPath(r'$[0]');
      expect(first.read({'0': 'foo'}), isEmpty);
    });
    test('Double index', () {
      final double = JsonPath(r'$[0,0]');
      final data = ['a'];
      expect(double.read(data).length, 2);
      expect(double.read(data).first.value, 'a');
      expect(double.read(data).first.path, r'$[0]');
      expect(double.read(data).last.value, 'a');
      expect(double.read(data).last.path, r'$[0]');
    });
    test('Index on scalar', () {
      final first = JsonPath(r'$[0]');
      expect(first.read('foo'), isEmpty);
    });
    test('Object', () {
      final abc = {
        'a': 'A',
        'b': 'B',
        'c': 'C',
      };
      final union = JsonPath(r"$['a',,'x',   c]");
      expect(union.read(abc).length, 2);
      expect(union.read(abc).first.value, 'A');
      expect(union.read(abc).first.path, r"$['a']");
      expect(union.read(abc).last.value, 'C');
      expect(union.read(abc).last.path, r"$['c']");
    });
  });

  group('Wildcards', () {
    test('All in root .*', () {
      final allInRoot = JsonPath(r'$.*');
      expect(allInRoot.read(json).length, 1);
      expect(allInRoot.read(json).single.value, json['store']);
      expect(allInRoot.read(json).single.path, r"$['store']");
    });
    test('All in root [*]', () {
      final allInRoot = JsonPath(r'$[*]');
      final data = {
        'some': 'string',
        'int': 42,
        'object': {
          'key': 'value'
        },
        'array': [
          0,
          1
        ]
      };
      expect(allInRoot.read(data).length, 4);
      expect(allInRoot.read(data).first.value, 'string');
      expect(allInRoot.read(data).first.path, r"$['some']");
      expect(allInRoot.read(data).last.value, [0, 1]);
      expect(allInRoot.read(data).last.path, r"$['array']");
    });
    test('All recursive', () {
      final allRecursive = JsonPath(r'$..[*]');
      expect(allRecursive.read(json).length, 27);
      final data = {
        'key': 'value',
        'another key': {
          'complex': 'string',
          'primitives': [0, 1]
        }
      };
      expect(allRecursive.read(data).length, 6);
    });

    test('All in store', () {
      final allInStore = JsonPath(r'$.store.*');
      expect(allInStore.read(json).length, 2);
      expect(allInStore.read(json).first.value, json['store']['book']);
      expect(allInStore.read(json).first.path, r"$['store']['book']");
      expect(allInStore.read(json).last.value, json['store']['bicycle']);
      expect(allInStore.read(json).last.path, r"$['store']['bicycle']");
    });
    test('No effect on scalars', () {
      final allInStore = JsonPath(r'$.store.bicycle.color.*');
      expect(allInStore.read(json), isEmpty);
    });
  });

  group('Recursion', () {
    test('Recursive', () {
      final allNode = JsonPath(r'$..');
      expect(allNode.read(json).length, 8);
      expect(allNode.read(json).first.value, json);
      expect(allNode.read(json).first.path, r'$');
      expect(allNode.read(json).last.value, json['store']['bicycle']);
      expect(allNode.read(json).last.path, r"$['store']['bicycle']");
    });

    test('Recursive with all values', () {
      final path = JsonPath(r'$..*');
      expect(path.read(json).length, 27);
      expect(path.read(json).first.value, json['store']);
      expect(path.read(json).first.path, r"$['store']");
      expect(path.read(json).last.value, json['store']['bicycle']['price']);
      expect(path.read(json).last.path, r"$['store']['bicycle']['price']");
    });

    test('Every price tag', () {
      final path = JsonPath(r'$..price');
      expect(path.read(json).length, 5);
      expect(path.read(json).first.value, json['store']['book'][0]['price']);
      expect(path.read(json).first.path, r"$['store']['book'][0]['price']");
      expect(path.read(json).last.value, json['store']['bicycle']['price']);
      expect(path.read(json).last.path, r"$['store']['bicycle']['price']");
    });
  });

  group('Lists', () {
    test('Path with an index', () {
      final path = JsonPath(r'$.store.book[0].title');
      expect(path.read(json).single.value, 'Sayings of the Century');
      expect(path.read(json).single.path, r"$['store']['book'][0]['title']");
    });

    test('Last element of array (regression #1)', () {
      final path = JsonPath(r"$['store']['book'][3]['price']");
      expect(path.read(json).single.value, 22.99);
      expect(path.read(json).single.path, r"$['store']['book'][3]['price']");
    });

    test('All in list', () {
      final path = JsonPath(r'$.store.book[*]');
      expect(path.read(json).length, 4);
      expect(path.read(json).first.value, json['store']['book'][0]);
      expect(path.read(json).first.path, r"$['store']['book'][0]");
      expect(path.read(json).last.value, json['store']['book'][3]);
      expect(path.read(json).last.path, r"$['store']['book'][3]");
    });
  });

  group('Filtering', () {
    test('Simple', () {
      final path = JsonPath(r'$.store..[?discounted]', filter: {
        'discounted': (e) => e is Map && e['price'] is num && e['price'] < 20
      });
      expect(path.read(json).length, 4);
      expect(path.read(json).first.value, json['store']['book'][0]);
      expect(path.read(json).first.path, r"$['store']['book'][0]");
      expect(path.read(json).last.value, json['store']['bicycle']);
      expect(path.read(json).last.path, r"$['store']['bicycle']");
    });

    test('Can be applied to scalars', () {
      final path = JsonPath(r'$.store..price[?low]',
          filter: {'low': (e) => e is num && e < 20});
      expect(path.read(json).length, 4);
      expect(path.read(json).first.value, json['store']['book'][0]['price']);
      expect(path.read(json).first.path, r"$['store']['book'][0]['price']");
      expect(path.read(json).last.value, json['store']['bicycle']['price']);
      expect(path.read(json).last.path, r"$['store']['bicycle']['price']");
    });

    test('Missing filter', () {
      expect(() => JsonPath(r'$.store..[?discounted]'), throwsFormatException);
    });
  });
  test('Modifying in-place', () {
    final someBooks = JsonPath(r'$.store.book[::2]');
    someBooks.read(json).forEach((result) {
      result.value['title'] = 'Banana';
    });
    expect(json['store']['book'][0]['title'], 'Banana');
    expect(json['store']['book'][1]['title'], 'Sword of Honour');
    expect(json['store']['book'][2]['title'], 'Banana');
    expect(json['store']['book'][3]['title'], 'The Lord of the Rings');
  });
}
