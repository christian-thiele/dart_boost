import 'dart:typed_data';

extension Uint8ListExtension on Uint8List {
  /// Returns a hexadecimal representation of the byte list.
  ///
  /// *Example:*
  /// ```dart
  /// final bytes = Uint8List.fromList([22, 255, 0, 32]);
  /// print(bytes.toHexString()); //
  /// ```
  String toHexString() {
    return map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}

extension IntListExtension on List<int> {
  /// Returns the Uint8List representation of this.
  ///
  /// [Uint8List] instances are often hidden behind the List<int>
  /// interface because of (backwards) compatibility with certain APIs.
  /// This method is a convenience method for checking if this is the case
  /// to avoid reallocation a new [Uint8List].
  ///
  /// If this is actually not a Uint8List 'Uint8List.fromList' is used
  /// to create one from the contents of this.
  Uint8List asUint8List() {
    if (this is Uint8List) {
      return this as Uint8List;
    }

    return Uint8List.fromList(this);
  }
}

extension IntListStreamExtension on Stream<List<int>> {
  /// Returns the Uint8List representation of this stream.
  ///
  /// [Uint8List] instances are often hidden behind the List<int>
  /// interface because of (backwards) compatibility with certain APIs.
  /// This method is a convenience method for checking if this is the case
  /// to avoid reallocation a new [Uint8List]s with every event.
  ///
  /// If the elements of this stream are actually not [Uint8List]s,
  /// 'Uint8List.fromList' is used to transform stream elements.
  Stream<Uint8List> asUint8List() {
    if (this is Stream<Uint8List>) {
      return this as Stream<Uint8List>;
    }

    return map((event) => event.asUint8List());
  }
}
