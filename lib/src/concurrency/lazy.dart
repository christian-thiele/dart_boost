import 'dart:async';

import 'package:boost/boost.dart';

/// A [Lazy] can be used to only initialize a value if it is required.
///
/// The [_initialize] function is guaranteed to only be called once by a
/// single instance of [Lazy].
///
/// If the first [get] call is still in progress, any subsequent call to [get]
/// will wait for the result of the first invocation and return the same result.
///
/// If [_initialize] throws an exception every call to [get] will re-throw this
/// exception.
class Lazy<T> {
  final _semaphore = Semaphore();
  final FutureOr<T> Function() _initialize;
  bool _initialized = false;
  dynamic _error;
  late T _value;

  Lazy(this._initialize);

  /// Returns true if the this [Lazy] already has a result.
  bool get isInitialized => _initialized;

  /// Receives the value returned by [initialize].
  ///
  /// This method only invokes [initialize] if it has not been called before.
  Future<T> get() async {
    if (_initialized) {
      if (_error != null) {
        throw _error;
      } else {
        return _value;
      }
    }

    return await _semaphore.runLocked(() async {
      if (!_initialized) {
        try {
          _value = await _initialize();
        } catch (e) {
          _error = e;
        } finally {
          _initialized = true;
        }
      }

      if (_error != null) {
        throw _error;
      }

      return _value;
    });
  }

  void invalidate() {
    _initialized = false;
    _error = null;
  }
}
