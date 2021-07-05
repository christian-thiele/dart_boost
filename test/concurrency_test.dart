import 'dart:io';
import 'dart:math';

import 'package:boost/boost.dart';
import 'package:pedantic/pedantic.dart';
import 'package:test/test.dart';

void main() {
  test('runGuarded', _runGuardedTest);
  test('cancelOn', _cancelOnTest);
  test('Semaphore.runLocked', _semaphoreTest);
  test('Semaphore.debounceLatest', _semaphoreTest);
}

Future _runGuardedTest() async {
  //TODO extend test cases
  final r = Random();
  final asyncNoFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) =>
          Future.delayed(Duration(milliseconds: r.nextInt(500))));
  final asyncFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            await Future.delayed(Duration(milliseconds: r.nextInt(500)));
            // this is to avoid return type 'Never'
            if (r.nextInt(10) < 20) {
              throw Exception('Async Task $i failed successfully.');
            }
            return 'won\'t happen';
          });

  final syncNoFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            sleep(Duration(milliseconds: r.nextInt(200)));
            return 'result';
          });

  final syncFailActions = Iterable.generate(
      10,
      (i) => (CancellationToken? token) async {
            sleep(Duration(milliseconds: r.nextInt(200)));
            if (i > -5) {
              throw Exception('Sync Task $i failed successfully.');
            }
            return 'result';
          });

  final guardResults1 =
      await runGuarded(asyncNoFailActions.followedBy(asyncFailActions));
  expect(guardResults1.map((e) => e.success), isNot(everyElement(isTrue)));

  final guardResults2 = await runGuarded(syncNoFailActions);
  expect(guardResults2.map((e) => e.success), everyElement(isTrue));

  final guardResults3 = await runGuarded(syncFailActions);
  expect(guardResults3.map((e) => e.error), everyElement(isNotNull));
}

Future _cancelOnTest() async {
  final token = CancellationToken();
  final future = Future.delayed(Duration(seconds: 3)).cancelOn(token);
  unawaited(
      Future.delayed(Duration(seconds: 1)).then((value) => token.cancel()));
  expect(() async => await future, throwsA(isA<CanceledException>()));

  final token2 = CancellationToken();
  final future2 =
      Future.delayed(Duration(seconds: 1)).then((v) => 'x').cancelOn(token2);
  await Future.delayed(Duration(seconds: 2));
  token2.cancel();
  expect(await future2, equals('x'));
}

Future _semaphoreTest() async {
  final results = <int>[];
  Future _someTask(int i, bool fail) async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(200)));
    results.add(i);
    if (fail) throw Exception();
  }

  final semaphore = Semaphore();
  await semaphore.runLocked(() async => _someTask(1, false));
  await semaphore.runLocked(() async => _someTask(2, false));
  expect(() async => await semaphore.runLocked(() async => _someTask(3, true)),
      throwsException);
  await semaphore.runLocked(() async => _someTask(4, false));

  expect(results, orderedEquals([1, 2, 3, 4]));
}

Future _semaphoreDebounceLatestTest() async {
  final results = <int>[];
  Future post(int x) async {
    await Future.delayed(Duration(seconds: 1));
    results.add(x);
  }

  final semaphore = Semaphore();
  semaphore.debounceLatest(() async => await post(1));
  semaphore.debounceLatest(() async => await post(2));
  semaphore.debounceLatest(() async => await post(3));
  semaphore.debounceLatest(() async => await post(4));
  semaphore.debounceLatest(() async => await post(5));
  await Future.delayed(Duration(seconds: 2));
  semaphore.debounceLatest(() async => await post(6));
  semaphore.debounceLatest(() async => await post(7));
  semaphore.debounceLatest(() async => await post(8));
  await Future.delayed(Duration(seconds: 2));
  semaphore.debounceLatest(() async => await post(9),
      delay: Duration(seconds: 1));
  semaphore.debounceLatest(() async => await post(10),
      delay: Duration(seconds: 1));
  semaphore.debounceLatest(() async => await post(11),
      delay: Duration(seconds: 1));
  await Future.delayed(Duration(seconds: 2));
  semaphore.debounceLatest(() async => await post(12),
      delay: Duration(seconds: 1));

  expect(results, orderedEquals([1, 5, 6, 8, 11, 12]));
}
