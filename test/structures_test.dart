import 'dart:convert';

import 'package:boost/boost.dart';
import 'package:test/test.dart';

void main() {
  test('Tuple', _tupleTest);
  test('Tuple to JSON', _tupleJsonTest);
  test('Triple', _tripleTest);
  test('Triple to JSON', _tripleJsonTest);
}

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

  // factory
  expect(Tuple.factory(5, 'a'), equals(Tuple(5, 'a')));
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

  // factory
  expect(Triple.factory(5, 'a', true), equals(Triple(5, 'a', true)));
}

void _tripleJsonTest() {
  final triple = Triple(5, 'test', true);
  expect(JsonEncoder().convert(triple), equals('[5,"test",true]'));
  final triple2 = Triple(null, 'test', false);
  expect(JsonEncoder().convert(triple2), equals('[null,"test",false]'));
}
