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
