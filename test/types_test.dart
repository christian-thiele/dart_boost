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
  expect(TypeCheck<int>().isList, isFalse);
  expect(TypeCheck<Map>().isList, isFalse);
  expect(TypeCheck<Map<String, int>>().isList, isFalse);
  expect(TypeCheck<List>().isList, isTrue);
  expect(TypeCheck<List<int>>().isList, isTrue);
  expect(TypeCheck<Null>().isList, isFalse);
  expect(TypeCheck<dynamic>().isList, isFalse);
  expect(TypeCheck<void>().isList, isFalse);
}

void _isListOfTypeTest() {
  expect(TypeCheck<List<int>>().isListOf<int>(), isTrue);
  expect(TypeCheck<List<int>>().isListOf<String>(), isFalse);
  expect(TypeCheck<List<String>>().isListOf<int>(), isFalse);
  expect(TypeCheck<List<String>>().isListOf<String>(), isTrue);
}

void _isMapTest() {
  expect(TypeCheck<int>().isMap, isFalse);
  expect(TypeCheck<Map>().isMap, isTrue);
  expect(TypeCheck<Map<String, int>>().isMap, isTrue);
  expect(TypeCheck<Map<Object, dynamic>>().isMap, isTrue);
  expect(TypeCheck<List>().isMap, isFalse);
  expect(TypeCheck<List<int>>().isMap, isFalse);
  expect(TypeCheck<Null>().isMap, isFalse);
  expect(TypeCheck<dynamic>().isMap, isFalse);
  expect(TypeCheck<void>().isMap, isFalse);
}

void _isMapOfTypeTest() {
  final jsonMap = TypeCheck<Map<String, dynamic>>();
  final intDoubleMap = TypeCheck<Map<int, double>>();

  expect(jsonMap.isMapOf<String, dynamic>(), isTrue);
  expect(jsonMap.isMapOf<dynamic, String>(), isFalse);
  expect(jsonMap.isMapOf<String, String>(), isFalse);

  expect(intDoubleMap.isMapOf<int, double>(), isTrue);
  expect(intDoubleMap.isMapOf<dynamic, dynamic>(), isTrue);
  expect(intDoubleMap.isMapOf<double, int>(), isFalse);
  expect(intDoubleMap.isMapOf<int, int>(), isFalse);

  expect(TypeCheck<dynamic>().isMapOf<int, int>(), isFalse);
  expect(TypeCheck<void>().isMapOf<int, int>(), isFalse);
  expect(TypeCheck<Null>().isMapOf<int, int>(), isFalse);
}

void _isSubtypeOfTest() {
  // true
  expect(TypeCheck<String>().isSubtypeOf<Object>(), isTrue);
  expect(TypeCheck<int>().isSubtypeOf<num>(), isTrue);
  expect(TypeCheck<String>().isSubtypeOf<dynamic>(), isTrue);
  expect(TypeCheck<List<int>>().isSubtypeOf<List<num>>(), isTrue);
  expect(TypeCheck<List<int>>().isSubtypeOf<List<dynamic>>(), isTrue);
  expect(TypeCheck<void>().isSubtypeOf<void>(), isTrue);

  //false
  expect(TypeCheck<int>().isSubtypeOf<String>(), isFalse);
  expect(TypeCheck<num>().isSubtypeOf<int>(), isFalse);
  expect(TypeCheck<void>().isSubtypeOf<String>(), isFalse);
}
