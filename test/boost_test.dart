import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:pedantic/pedantic.dart';
import 'package:test/test.dart';
import 'package:boost/boost.dart';

void main() {
  group('Structures', () {
    test('Tuple', _tupleTest);
    test('Tuple to JSON', _tupleJsonTest);
    test('Triple', _tripleTest);
    test('Triple to JSON', _tripleJsonTest);
  });

  group('Strings', () {
    test('nullOrEmpty', _nullOrEmptyTest);
    test('nullOrWhitespace', _nullOrWhitespaceTest);
  });

  group('Collections', () {
    test('whereNotNull', _whereNotNullTest);
    test('firstWhereNotNull', _firstOrNullWhereTest);
    test('random', _randomTest);
    test('distinct', _distinctTest);
    test('groupBy', _groupByTest);
    test('sequenceEquals', _sequenceEqualsTest);
    test('split', _splitTest);
    test('zip', _zipTest);
    test('replaceItem', _replaceItemTest);
    test('sortBy', _sortByTest);
    test('min / max', _minMaxTest);
    test('whereIs', _whereIsTest);
  });

  group('Types', () {
    test('isList', _isListTest);
    test('isListOfType', _isListOfTypeTest);
    test('isMap', _isMapTest);
    test('isMapOfType', _isMapOfTypeTest);
  });

  group('Math', () {
    test('round', _roundTest);
  });

  group('Concurrency', () {
    test('runGuarded', _runGuardedTest);
    test('cancelOn', _cancelOnTest);
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

void _tupleJsonTest() {
  final tuple = Tuple(5, 'test');
  expect(JsonEncoder().convert(tuple), equals('[5,"test"]'));
  final tuple2 = Tuple(null, 'test');
  expect(JsonEncoder().convert(tuple2), equals('[null,"test"]'));
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

void _tripleJsonTest() {
  final triple = Triple(5, 'test', true);
  expect(JsonEncoder().convert(triple), equals('[5,"test",true]'));
  final triple2 = Triple(null, 'test', false);
  expect(JsonEncoder().convert(triple2), equals('[null,"test",false]'));
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

void _firstOrNullWhereTest() {
  final list = [1, 3, 5, 7, -5, 25];
  final result = list.firstOrNullWhere((e) => e > 5);
  expect(result, equals(7));

  final list2 = [1, 3, 5, 2, -5, -25];
  final result2 = list2.firstOrNullWhere((e) => e > 5);
  expect(result2, equals(null));
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
  expect(
      groups,
      equals({
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

void _minMaxTest() {
  final intList = <int>[1, 3, 56, 2, 4, 1, 85, 5, -23, 3, 0];
  final doubleList = <double>[1.2, 3.4, 56.321, 2.0, 4.12, 5.6537, -23.34, 0.0];
  final doubleListInf = <double>[
    double.infinity,
    double.nan,
    double.negativeInfinity,
    -23.34,
    0.0
  ];
  final numList = <num>[3.4, 56.321, 2, 4.12, 12, 85.435, 5, -23.34, 3, 0.0];
  final stringList = <String>['test', 'a', 'b', 'longword!', 'abcdefg'];

  expect(intList.min(), equals(-23));
  expect(intList.max(), equals(85));
  expect(doubleList.min(), equals(-23.34));
  expect(doubleList.max(), equals(56.321));
  expect(doubleListInf.min(), equals(double.negativeInfinity));
  expect(doubleListInf.max(), equals(double.infinity));
  expect(numList.min(), equals(-23.34));
  expect(numList.max(), equals(85.435));
  expect(stringList.min((s) => s.length), equals('a'));
  expect(stringList.max((s) => s.length), equals('longword!'));

  expect(() => stringList.min(), throwsA(isA<BoostException>()));
  expect(() => stringList.max(), throwsA(isA<BoostException>()));
}

void _whereIsTest() {
  final list = ['test', 123, true, null, 'test2', 0.4, (a, b) => a + b];
  expect(list.whereIs<String>(), orderedEquals(['test', 'test2']));
  expect(list.whereIs<int>(), orderedEquals([123]));
  expect(list.whereIs<num>(), orderedEquals([123, 0.4]));
  expect(list.whereIs<bool>(), orderedEquals([true]));
  expect(list.whereIs<Null>(), orderedEquals([null]));
  expect(list.whereIs<double>(), orderedEquals([0.4]));
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

// Math
void _roundTest() {
  expect(round(0), equals(0));
  expect(round(10), equals(10));
  expect(round(10, -2), equals(0));
  expect(round(10, 2), equals(10));
  expect(round(1.25, 1), equals(1.3));
  expect(round(-1.25, 1), equals(-1.3));
  expect(round(545, -1), equals(550));
  expect(round(545, -2), equals(500));
  expect(round(545, 0), equals(545));
  expect(round(545, 2), equals(545));
  expect(round(545, -3), equals(1000));

  expect(round(double.infinity, 2), equals(double.infinity));
  expect(round(double.negativeInfinity, 2), equals(double.negativeInfinity));
  expect(round(double.nan, 2), isNaN);
}

// Concurrency
Future _runGuardedTest() async {
  //TODO extend test cases
  final r = Random();
  final asyncNoFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) =>
          Future.delayed(Duration(milliseconds: r.nextInt(500))));
  final asyncFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            await Future.delayed(Duration(milliseconds: r.nextInt(500)));
            // this is to avoid return type 'Never'
            if (r.nextInt(10) < 20) {
              throw Exception('Async Task $i failed successfully.');
            }
            return 'won\'t happen';
          });

  final syncNoFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            sleep(Duration(milliseconds: r.nextInt(200)));
            return 'result';
          });

  final syncFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            sleep(Duration(milliseconds: r.nextInt(200)));
            if (i > -5) {
              throw Exception('Sync Task $i failed successfully.');
            }
            return 'result';
          });

  final guardResults1 =
      await runGuarded(asyncNoFailActions.followedBy(asyncFailActions));
  expect(guardResults1.map((e) => e.success), isNot(everyElement(isTrue)));

  final guardResults2 = await runGuarded(syncNoFailActions);
  expect(guardResults2.map((e) => e.success), everyElement(isTrue));

  final guardResults3 = await runGuarded(syncFailActions);
  expect(guardResults3.map((e) => e.error), everyElement(isNotNull));
}

Future _cancelOnTest() async {
  final token = CancellationToken();
  final future = Future.delayed(Duration(seconds: 3)).cancelOn(token);
  unawaited(
      Future.delayed(Duration(seconds: 1)).then((value) => token.cancel()));
  expect(() async => await future, throwsA(isA<CanceledException>()));
}
