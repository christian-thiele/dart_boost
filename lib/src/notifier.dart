class Notifier {
  final Map<Object, Function> _listeners = {};

  /// Calls all attached listeners.
  void notify() {
    _listeners.values.forEach((listener) => listener.call());
  }

  /// Attaches a function that will be executed when notify() is called.
  ///
  /// Returns a key object that can be used to detach the listener
  /// from  the notifier to stop execution on notify() call and
  /// avoid memory leaks.
  Object attach(Function listener) {
    final key = Object();
    _listeners[key] = listener;
    return key;
  }

  /// Detaches a listener function.
  ///
  /// The [key] param used to identify a listener is returned by the attach
  /// method.
  void detach(Object key) => _listeners.remove(key);
}
