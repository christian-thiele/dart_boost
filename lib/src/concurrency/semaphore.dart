import 'dart:async';

import 'package:boost/boost.dart';

/// A semaphore prevents asynchronous code from being executed simultaneously.
class Semaphore {
  Completer? completer;
  Tuple<DateTime, FutureOr Function()>? _latest;

  bool get isLocked => !(completer?.isCompleted ?? true);

  /// Function [job] is executed immediately if the semaphore is not locked,
  /// as soon as the last scheduled job finishes otherwise.
  Future<TResult> runLocked<TResult>(FutureOr<TResult> Function() job) async {
    try {
      await lock();
      return await job();
    } finally {
      release();
    }
  }

  /// Function [job] is executed only if the semaphore is not locked.
  Future<TResult?> debounce<TResult>(FutureOr<TResult> Function() job) async {
    if (isLocked) {
      return null;
    }

    try {
      await lock();
      return await job();
    } finally {
      release();
    }
  }

  /// Function [job] is executed only if no other jobs are scheduled within
  /// the [delay] period.
  ///
  /// Since this method cannot be awaited, exceptions will not thrown
  /// to the caller so make sure to catch potential exceptions inside the [job].
  void debounceLatest(FutureOr Function() job, {Duration? delay}) async {
    final thisJob = Tuple(DateTime.now(), job);
    _latest = thisJob;

    if (delay != null) {
      await Future.delayed(delay);
    }

    if (!isLocked) {
      await runLocked(job);
    } else {
      await runLocked(() async {
        if (_latest == thisJob) {
          await job();
        }
      });
    }
  }

  /// Locks the semaphore. The Future completes as soon as the semaphore is
  /// released and can be locked again.
  ///
  /// Most of the time [runLocked] and [debounce] should be preferred.
  Future lock() async {
    if (completer != null) {
      await completer!.future;
      await lock();
    }
    completer = Completer();
  }

  /// Releases the current lock on the semaphore.
  ///
  /// This is only necessary for special use cases in conjunction with [lock].
  /// Most of the time [runLocked] and [debounce] should be preferred.
  void release() {
    completer?.complete();
    completer = null;
  }
}
