import 'dart:typed_data';

import 'package:boost/boost.dart';
import 'package:test/test.dart';

void main() {
  test('toHexString', _toHexStringTest);
}

void _toHexStringTest() {
  final bytes = Uint8List.fromList([22, 255, 0, 32, 12]);
  expect(bytes.toHexString(), equals('16ff00200c'));
}
