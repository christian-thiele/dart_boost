## 0.0.1-nullsafety
- Initial version

## 0.0.2-nullsafety
- IterableExtension
  - distinct
  - groupBy
  - sequenceEquals
  - split

- ListExtension
  - replaceItem
  - sortBy

## 0.0.3-nullsafety
- Concurrency
  - CancellationToken
  - runGuarded
- Notifier
- String Utils
  - nullOrEmpty
  - nullOrWhitespace

## 0.0.4-nullsafety
- Collections
  - min
  - max
- Math
  - round
- Structures
  - toJson for Tuples / Triples

## 0.0.5-nullsafety
- Collections
  - firstOrNullWhere

## 0.0.6-nullsafety
- Collections
  - whereIs
  - a, b, c for tuple / triple iterables

## 0.0.7-nullsafety
- Concurrency
  - Semaphore

## 0.0.8-nullsafety
- Notifier
  - addOneShot

## 0.0.9-nullsafety
- Enums
  - findEnum
  - tryFindEnum

## 0.0.10-nullsafety
- Enums
  - enumName
  
## 0.0.11-nullsafety
- Math
  - clamp
- Concurrency
  - Semaphore.debounceLatest
  
## 1.0.0
- First Major Release!
- _Breaking API change:_
Semaphore.debounce() was renamed to Semaphore.throttle to match
reactive conventions.
Semaphore.debounce was added with correct debounce functionality.
- fixed bug in Semaphore.debounce()

## 1.1.0
- Types
  - isSubtypeOf

## 1.2.0
- Math
  - toRadians
  - toDegrees

## 1.3.0
- Tuple.factory
- Triple.factory

## 1.4.0
- ConfigParser

## 1.5.0
- Bytes
  - toHexString

## 1.5.1
- Config
  - fixed null handling for string arguments

## 1.5.2
- CancellationToken
  - cancelOn: fixed "Future already completed" exception when calling cancel() after target Future completed

## 1.6.0
- Version

## 1.7.0
- TypeCheck replaces Type extension methods
  - this fixes flutter web compatibility