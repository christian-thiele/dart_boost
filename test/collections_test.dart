import 'package:boost/boost.dart';
import 'package:test/test.dart';

void main() {
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
  test('tuple a/b', _tupleIterableTest);
  test('triple a/b/c', _tripleIterableTest);
}

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

void _tupleIterableTest() {
  final list = [Tuple('1', 1), Tuple('2', 2), Tuple('3', 3)];
  expect(list.a, orderedEquals(['1', '2', '3']));
  expect(list.b, orderedEquals([1, 2, 3]));
}

void _tripleIterableTest() {
  final list = [
    Triple('1', 1, true),
    Triple('2', 2, 'abc'),
    Triple('3', 3, false)
  ];
  expect(list.a, orderedEquals(['1', '2', '3']));
  expect(list.b, orderedEquals([1, 2, 3]));
  expect(list.c, orderedEquals([true, 'abc', false]));
}
