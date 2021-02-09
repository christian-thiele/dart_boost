import 'dart:math' as math;

import 'package:boost/src/exceptions.dart';

import 'structures.dart';

bool notNull(e) => e != null;

bool isNull(e) => e == null;

extension NullableIterableExtension<TValue> on Iterable<TValue?> {
  /// ensure null-safety in iterable
  Iterable<TValue> get whereNotNull => where(notNull).map((e) => e!);
}

extension IterableExtension<TValue> on Iterable<TValue> {
  /// Returns the first element of the iterable if not empty, null otherwise.
  TValue? get firstOrNull => isNotEmpty ? first : null;

  /// Returns the last element of the iterable if not empty, null otherwise.
  TValue? get lastOrNull => isNotEmpty ? last : null;

  /// Returns a random element.
  TValue get random {
    if (isEmpty) {
      return first; // supposed to trigger internal noElement exception
    }

    return elementAt(math.Random().nextInt(length));
  }

  /// Returns a subset of this [Iterable] containing every element whose key is
  /// not equal to the key of any previous element.
  ///
  /// If [keySelector] is null, the element itself is considered as key.
  Iterable<TValue> distinct([Function(TValue)? keySelector]) sync* {
    final keys = [];
    for (final element in this) {
      final key = (keySelector == null) ? element : keySelector(element);
      if (keys.contains(key)) continue;
      keys.add(key);
      yield element;
    }
  }

  /// Groups elements of this [iterable] by comparing the [selector] result.
  Map<TKey, List<TValue>> groupBy<TKey>(TKey Function(TValue) selector) {
    final map = <TKey, List<TValue>>{};
    forEach((element) {
      final key = selector(element);
      if (map[key] == null) {
        map[key] = [element];
      } else {
        map[key]!.add(element);
      }
    });
    return map;
  }

  /// Deep equality check.
  ///
  /// Checks if elements in [other] are equal to the elements in this [Iterable].
  bool sequenceEquals(Iterable<TValue> other) {
    if (this == other) {
      return true;
    }

    if (other.length != length) {
      return false;
    }

    for (final pair in zip(other)) {
      if (pair.a != pair.b) {
        return false;
      }
    }

    return true;
  }

  /// Splits the collection into two subsets.
  ///
  /// Every element for which [selector] returns true is added to the
  /// [Tuple.a] list, otherwise it is added to the [Tuple.b] list.
  Tuple<List<TValue>, List<TValue>> split(bool Function(TValue) selector) {
    final collections = Tuple<List<TValue>, List<TValue>>([], []);
    forEach((element) {
      final collection = selector(element) ? collections.a : collections.b;
      collection.add(element);
    });
    return collections;
  }

  /// Merges every element of this [Iterable] with the corresponding element
  /// of [other] into a [Tuple].
  ///
  /// If this and [other] have varying lengths, null will be substituted for
  /// the missing counter part in the result [Tuple].
  Iterable<Tuple<TValue?, TOther?>> zip<TOther>(Iterable<TOther> other) {
    return Iterable.generate(
        math.max(length, other.length),
        (i) => Tuple(length > i ? elementAt(i) : null,
            other.length > i ? other.elementAt(i) : null));
  }

  /// Finds the element with the smallest value selected by the selector function.
  ///
  /// All values returned by the selector must be of type num.
  /// If selector is null, the elements itself become the selected elements.
  TValue min([Function(TValue)? selector]) {
    selector ??= (e) => e;

    TValue? minObject;
    num? minValue;

    for (final element in this) {
      final value = selector(element);
      if (value == null) {
        throw BoostException('Selector for element ${element} returned null!');
      } else if (value is! num) {
        throw BoostException(
            'Selector for element ${element} did not return num!');
      }

      if (minValue == null || value < minValue) {
        minObject = element;
        minValue = value;
      }
    }

    if (minObject == null) {
      throw BoostException('Iterable is empty.');
    }

    return minObject;
  }

  /// Finds the element with the largest value selected by the selector function.
  ///
  /// All values returned by the selector must be of type num.
  /// If selector is null, the elements itself become the selected elements.
  TValue max([Function(TValue)? selector]) {
    selector ??= (e) => e;

    TValue? maxObject;
    num? maxValue;
    for (final element in this) {
      final value = selector(element);
      if (value == null) {
        throw BoostException('Selector for element ${element} returned null!');
      } else if (value is! num) {
        throw BoostException(
            'Selector for element ${element} did not return num!');
      }

      if (maxValue == null || value > maxValue) {
        maxObject = element;
        maxValue = value;
      }
    }

    if (maxObject == null) {
      throw BoostException('Iterable is empty.');
    }

    return maxObject;
  }
}

extension ListExtension<TValue> on List<TValue> {
  /// Replaces a single element of this [List] with [replacement].
  ///
  /// Removes the first object which is equal to [needle],
  /// then inserts [replacements] at the former index of [needle].
  void replaceItem(TValue needle, TValue replacement, [int start = 0]) {
    final idx = indexOf(needle, start);
    if (idx == -1) {
      throw BoostException('Item not found in list.');
    }
    replaceRange(idx, idx + 1, [replacement]);
  }

  /// Sorts this [List] by comparing the keys returned by the [selector].
  void sortBy<TKey extends Comparable>(TKey Function(TValue) selector,
      [bool ascending = true]) {
    sort((a, b) => ascending
        ? Comparable.compare(selector(a), selector(b))
        : Comparable.compare(selector(b), selector(a)));
  }
}
