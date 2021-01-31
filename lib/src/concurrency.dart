import 'dart:async';

import 'package:boost/src/concurrency/cancellation_token.dart';

class GuardResult {}

enum FailMode { FailFast, Report }

enum ExecutionMode { Serial, Parallel }

Future<GuardResult> runGuarded(List<FutureOr Function()> actions,
    {FailMode failMode = FailMode.Report,
    ExecutionMode executionMode = ExecutionMode.Parallel,
    CancellationToken? cancel}) {
}