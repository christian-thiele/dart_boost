import 'package:test/test.dart';
import 'package:boost/boost.dart';

void main() {
  test('isList', _isListTest);
  test('isListOfType', _isListOfTypeTest);
  test('isMap', _isMapTest);
  test('isMapOfType', _isMapOfTypeTest);
  test('isSubtypeOf', _isSubtypeOfTest);
}

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

void _isSubtypeOfTest() {
  // true
  expect(isSubtypeOf<String, Object>(), isTrue);
  expect(isSubtypeOf<int, num>(), isTrue);
  expect(isSubtypeOf<String, dynamic>(), isTrue);
  expect(isSubtypeOf<List<int>, List<num>>(), isTrue);
  expect(isSubtypeOf<List<int>, List<dynamic>>(), isTrue);

  //false
  expect(isSubtypeOf<int, String>(), isFalse);
  expect(isSubtypeOf<num, int>(), isFalse);
}
