import 'dart:async';

import 'package:boost/src/concurrency/cancellation_token.dart';
import 'package:pedantic/pedantic.dart';

class GuardResult<T> {
  T? result;
  dynamic error;
  StackTrace? stackTrace;

  GuardResult({this.result, this.error, this.stackTrace});

  bool get success => error == null;
}

enum FailMode { FailFast, Report }

enum ExecutionMode { Serial, Parallel }

Future<List<GuardResult<T>>> runGuarded<T>(
    List<FutureOr Function(CancellationToken?)> actions,
    {FailMode failMode = FailMode.Report,
      ExecutionMode executionMode = ExecutionMode.Parallel,
      CancellationToken? cancel}) async {
  final tasks = <Future>[];
  final results = <GuardResult<T>>[];

  for (final action in actions) {
    try {
      final future = action(cancel);
      if (future is Future) {
        switch (executionMode) {
          case ExecutionMode.Serial:
            results.add(GuardResult(result: await future));
            break;
          case ExecutionMode.Parallel:
            unawaited(future.catchError((e, stack) =>
                results.add(GuardResult(error: e, stackTrace: stack))));
            break;
        }
        tasks.add(future);
      }
    } catch (e, stack) {
      results.add(GuardResult(error: e, stackTrace: stack));
      if (failMode == FailMode.FailFast) {
          rethrow;
      }
    }
  }

  for (final task in tasks) {
    try {
      final result = await task;
      results.add(GuardResult(result: result));
    } catch (e, stack) {
      results.add(GuardResult(error: e, stackTrace: stack));
    }
  }

  return results;
}