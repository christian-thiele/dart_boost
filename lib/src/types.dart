/// A utility class for checking type parameters.
class TypeCheck<T> {
  /// Checks if [T] is a [List] of any type.
  ///
  /// See [isSubtypeOf] for further info.
  bool get isList => isSubtypeOf<List>();

  /// Checks if [T] is a [Map] of any type.
  ///
  /// See [isSubtypeOf] for further info.
  bool get isMap => isSubtypeOf<Map>();

  bool isListOf<E>() => isSubtypeOf<List<E>>();
  bool isMapOf<K, V>() => isSubtypeOf<Map<K, V>>();

  /// Returns true if instance of [T] is applicable to [TBase],
  /// as if you would check `new T() is TBase`.
  ///
  /// WARNING:
  /// `isSubtypeOf<T, void>()`
  /// will always return true, since void is dynamic at runtime.
  ///
  /// To check if T is void, use:
  /// `isSubtypeOf<void, T>()`
  /// which does not work for dynamic (as stated above).
  bool isSubtypeOf<TBase>() {
    return this is TypeCheck<TBase>;
  }
}
