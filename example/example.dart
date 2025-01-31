import 'dart:convert';

import 'package:json_path/json_path.dart';

void main() {
  final document = jsonDecode('''
{
  "store": {
    "book": [
      {
        "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      {
        "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      {
        "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.99
      },
      {
        "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}  
  ''');

  final prices = JsonPath(r'$.store.book');

  print('All prices in the store:');

  /// The following code will print:
  ///
  /// /store/book/0/price:	8.95
  /// /store/book/1/price:	12.99
  /// /store/book/2/price:	8.99
  /// /store/book/3/price:	22.99
  /// /store/bicycle/price:	19.95
  prices
      .read(document)
      .map((match) => '${match.pointer}:\t${match.value}')
      .forEach(print);
}
