import 'dart:math';

import 'package:boost/src/strings.dart';
import 'package:boost/src/structures.dart';
import 'package:test/test.dart';
import 'package:boost/boost.dart';

void main() {
  group('Structures', () {
    test('Tuple', _tupleTest);
    test('Triple', _tripleTest);
  });

  group('Strings', () {
    test('nullOrEmpty', _nullOrEmptyTest);
    test('nullOrWhitespace', _nullOrWhitespaceTest);
  });

  group('Collections', () {
    test('whereNotNull', _whereNotNullTest);
    test('random', _randomTest);
    test('distinct', _distinctTest);
    test('groupBy', _groupByTest);
    test('sequenceEquals', _sequenceEqualsTest);
    test('split', _splitTest);
    test('zip', _zipTest);
    test('replaceItem', _replaceItemTest);
    test('sortBy', _sortByTest);
  });

  group('Types', () {
    test('isList', _isListTest);
    test('isListOfType', _isListOfTypeTest);
    test('isMap', _isMapTest);
    test('isMapOfType', _isMapOfTypeTest);
  });
}

// Structures
void _tupleTest() {
  final tuple = Tuple(5, 'text');
  expect(tuple.a, equals(5));
  expect(tuple.b, equals('text'));

  final withA = tuple.withA(9);
  expect(withA.a, equals(9));
  expect(withA.b, equals('text'));

  final withB = tuple.withB('other');
  expect(withB.a, equals(5));
  expect(withB.b, equals('other'));

  // equality comparator
  expect(tuple, equals(tuple));
  expect(tuple, isNot(equals(withA)));
  expect(tuple, isNot(equals(withB)));

  expect(withA, isNot(equals(tuple)));
  expect(withA, equals(withA));
  expect(withA, isNot(equals(withB)));

  expect(withB, isNot(equals(tuple)));
  expect(withB, isNot(equals(withA)));
  expect(withB, equals(withB));

  expect(tuple, equals(withA.withA(tuple.a)));
  expect(tuple, equals(withB.withB(tuple.b)));
  expect(withB.withA(withA.a), equals(withA.withB(withB.b)));
}

void _tripleTest() {
  final dt = DateTime.now();
  final dt2 = dt.add(Duration(days: 1));

  final triple = Triple(0.4, dt, false);
  expect(triple.a, equals(0.4));
  expect(triple.b, equals(dt));
  expect(triple.c, equals(false));

  final withA = triple.withA(9);
  expect(withA.a, equals(9.0));
  expect(withA.b, equals(dt));
  expect(withA.c, equals(false));

  final withB = triple.withB(dt2);
  expect(withB.a, equals(0.4));
  expect(withB.b, equals(dt2));
  expect(withB.c, equals(false));

  final withC = triple.withC(true);
  expect(withC.a, equals(0.4));
  expect(withC.b, equals(dt));
  expect(withC.c, equals(true));

  // equality comparator
  expect(triple, equals(triple));
  expect(triple, isNot(equals(withA)));
  expect(triple, isNot(equals(withB)));
  expect(triple, isNot(equals(withC)));

  expect(withA, isNot(equals(triple)));
  expect(withA, equals(withA));
  expect(withA, isNot(equals(withB)));
  expect(withA, isNot(equals(withC)));

  expect(withB, isNot(equals(triple)));
  expect(withB, isNot(equals(withA)));
  expect(withB, equals(withB));
  expect(withB, isNot(equals(withC)));

  expect(triple, equals(withA.withA(triple.a)));
  expect(triple, equals(withB.withB(triple.b)));
  expect(triple, equals(withC.withC(triple.c)));

  expect(withB.withA(withA.a), equals(withA.withB(withB.b)));
  expect(withC.withA(withA.a), equals(withA.withC(withC.c)));
}

// Strings
void _nullOrEmptyTest() {
  expect(nullOrEmpty(''), isTrue);
  expect(nullOrEmpty(null), isTrue);
  expect(nullOrEmpty(' '), isFalse);
  expect(nullOrEmpty('abc'), isFalse);
  expect(nullOrEmpty('\t'), isFalse);
  expect(nullOrEmpty('.'), isFalse);
}

void _nullOrWhitespaceTest() {
  expect(nullOrWhitespace(''), isTrue);
  expect(nullOrWhitespace(null), isTrue);
  expect(nullOrWhitespace(' '), isTrue);
  expect(nullOrWhitespace('\t '), isTrue);
  expect(nullOrWhitespace('\t'), isTrue);
  expect(nullOrWhitespace(' abc'), isFalse);
  expect(nullOrWhitespace('.'), isFalse);
}

// Collections
void _whereNotNullTest() {
  final list = [1, 3, 5, 2, null, 2, null, 0, 7];
  final result = list.whereNotNull;
  expect(result, isNot(contains(null)));
}

void _randomTest() {
  final intList = Iterable.generate(20, (i) => 'str$i');
  final results = Iterable.generate(10, (i) => intList.random);
  final firstResult = results.first;

  expect(results, isNot(everyElement(equals(firstResult))));
}

void _distinctTest() {
  final text = 'abc def ghi def abc jkl mno ghi';
  final distinct = text.split(' ').distinct();
  expect(distinct, ['abc', 'def', 'ghi', 'jkl', 'mno']);

  final list = [
    Tuple(1, 'first 1'),
    Tuple(2, 'first 2'),
    Tuple(1, 'second 1'),
    Tuple(3, 'first 3')
  ];
  expect(list.distinct((e) => e.a).map((e) => e.b),
      ['first 1', 'first 2', 'first 3']);
}

void _groupByTest() {
  final people = ['Joe', 'Alex', 'Grace', 'Tina', 'Max'];
  final groups = people.groupBy((e) => e.length);
  expect(groups, equals({
    3: ['Joe', 'Max'],
    4: ['Alex', 'Tina'],
    5: ['Grace']
  }));
}

void _sequenceEqualsTest() {
  final seq1 = [1, 2, 5, 7, 9, 20];
  final seq2 = [1, 2, 5, 7, 9, 20];
  final seq3 = [1, 2, 5, 7, 20, 9];
  final seq4 = [1, 2, 5, 7];

  expect(seq1.sequenceEquals(seq1), isTrue);
  expect(seq1.sequenceEquals(seq2), isTrue);
  expect(seq1.sequenceEquals(seq3), isFalse);
  expect(seq3.sequenceEquals(seq1), isFalse);
  expect(seq3.sequenceEquals(seq2), isFalse);
  expect(seq1.sequenceEquals(seq4), isFalse);
}

void _splitTest() {
  final people = [
    Tuple('Joe', false),
    Tuple('Alex', true),
    Tuple('Grace', true),
    Tuple('Tina', false),
    Tuple('Max', false),
  ];

  final split = people.split((p) => p.b);
  expect(split.a, equals(people.where((p) => p.b)));
  expect(split.b, equals(people.where((p) => !p.b)));
}

void _zipTest() {
  final seq1 = ['a', 'b', 'c', 'd'];
  final seq2 = [5, 4, 3, 2, 1, 0];
  final combined = seq1.zip(seq2);

  expect(
      combined,
      equals(<Tuple<String?, int?>>[
        Tuple('a', 5),
        Tuple('b', 4),
        Tuple('c', 3),
        Tuple('d', 2),
        Tuple(null, 1),
        Tuple(null, 0),
      ]));
}

void _replaceItemTest() {
  final seq = <dynamic>['abc', 2, 0.4, false];
  seq.replaceItem(0.4, 'def');
  expect(seq, equals(['abc', 2, 'def', false]));
}

void _sortByTest() {
  final list = [
    Tuple('g', 5),
    Tuple('e', 2),
    Tuple('u', 8),
    Tuple('a', 3),
    Tuple('f', 10),
    Tuple('i', 4),
  ];

  list.sortBy((e) => e.a);
  expect(list.map((e) => e.b), [3, 2, 10, 5, 4, 8]);

  list.sortBy((e) => e.b);
  expect(list.map((e) => e.b), [2, 3, 4, 5, 8, 10]);
}

// Types
void _isListTest() {
  expect((int).isList, isFalse);
  expect((Map).isList, isFalse);
  expect((List).isList, isTrue);
}

void _isListOfTypeTest() {
  final intList = [1, 2, 3];
  final strList = ['str1', 'str2'];

  expect(intList.runtimeType.isListOfType<int>(), isTrue);
  expect(intList.runtimeType.isListOfType<String>(), isFalse);
  expect(strList.runtimeType.isListOfType<int>(), isFalse);
  expect(strList.runtimeType.isListOfType<String>(), isTrue);
}

void _isMapTest() {
  expect((int).isMap, isFalse);
  expect((Map).isMap, isTrue);
  expect((List).isMap, isFalse);
}

void _isMapOfTypeTest() {
  final jsonMap = <String, dynamic>{'int': 1, 'str': 'value2', 'bool': true};
  final intDoubleMap = {1: 0.325, 2: 0.1284, 3: 0.954};

  expect(jsonMap.runtimeType.isMapOfType<String, dynamic>(), isTrue);
  expect(jsonMap.runtimeType.isMapOfType<dynamic, String>(), isFalse);
  expect(jsonMap.runtimeType.isMapOfType<String, String>(), isFalse);

  expect(intDoubleMap.runtimeType.isMapOfType<int, double>(), isTrue);
  expect(intDoubleMap.runtimeType.isMapOfType<dynamic, dynamic>(), isFalse);
  expect(intDoubleMap.runtimeType.isMapOfType<double, int>(), isFalse);
  expect(intDoubleMap.runtimeType.isMapOfType<int, int>(), isFalse);
}
