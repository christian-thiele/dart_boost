import 'dart:math';

/// Rounds to given digit count.
///
/// If [digits] is positive, the number is rounded to the nth digit after the
/// decimal point. If [digits] is negative, the number is rounded to the nth
/// digit in front of the decimal point.
/// Rounds away from zero on n.5:
///  `round(35, -1) == 40` and `round(-35, -1) == -40`.
///  `round(1.25, 1) == 1.3` and `round(-1.25, 1) == -1.3`.
double round<T extends num>(T value, [int digits = 0]) {
  if (value is double && (value.isNaN || value.isInfinite)) {
    return value;
  }

  final p = pow(10, 0 - digits);
  return ((value / p).round() * p).toDouble();
}
