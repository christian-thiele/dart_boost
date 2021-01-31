import 'package:boost/src/notifier.dart';

import 'canceled_exception.dart';

class CancellationToken {
  final Notifier _notifier = Notifier();
  bool _cancellationRequested = false;

  bool get cancellationRequested => _cancellationRequested;


  void throwIfCanceled() {
    if (cancellationRequested) {
      throw CanceledException();
    }
  }

  void cancel() {
    _cancellationRequested = true;
    _notifier.notify();
  }

  /// Attaches a function that will be called when the [CancellationToken]
  /// is canceled.
  ///
  /// See [Notifier].attach().
  Object attach(Function listener) => _notifier.attach(listener);

  /// Detaches a function from the [CancellationToken] so it will not be called
  /// any more.
  ///
  /// See [Notifier].detach().
  void detach(Object key) => _notifier.detach(key);
}