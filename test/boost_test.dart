import 'package:test/test.dart';
import 'package:boost/boost.dart';

void main() {
  group('Collections', () {
    test('whereNotNull', _whereNotNullTest);
    test('random', _randomTest);
  });

  group('Types', () {
    test('isList', _isListTest);
    test('isListOfType', _isListOfTypeTest);
    test('isMap', _isMapTest);
    test('isMapOfType', _isMapOfTypeTest);
  });
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
