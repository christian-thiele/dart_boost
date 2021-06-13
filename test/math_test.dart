import 'package:boost/boost.dart';
import 'package:test/test.dart';

void main() {
  test('round', _roundTest);
}

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
