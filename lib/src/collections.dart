import 'dart:math';

/// selector / test delegates for methods like where(), any(), etc.
bool notNull(e) => e != null;
bool isNull(e) => e == null;

extension NullableIterableExtension<TValue> on Iterable<TValue?> {
  /// ensure null-safety in iterable
  Iterable<TValue> get whereNotNull => where(notNull).map((e) => e!);
}

extension IterableUtils<TValue> on Iterable<TValue> {
  /// picks a random element of the iterable
  TValue get random {
    if (isEmpty) {
      return first; // supposed to trigger internal noElement exception
    }

    return elementAt(Random().nextInt(length));
  }
}