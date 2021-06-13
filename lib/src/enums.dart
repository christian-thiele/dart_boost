import 'package:boost/boost.dart';

/// Finds and returns the enum value which matches with the given string value.
///
/// The comparison is case sensitive by default. Be careful when using
/// [ignoreCase] as dart allows different enum values with only case difference.
/// If no value matches, a [BoostException] is thrown. For `null` instead of
/// an exception, use [tryFindEnum].
///
/// *Example:*
/// ```dart
/// enum MyEnum { first, second, third }
/// ...
/// final value = findEnum('second', MyEnum.values);
/// ```
TEnum findEnum<TEnum>(String value, List<TEnum> values,
    {bool ignoreCase = false}) {
  return tryFindEnum(value, values) ??
      (throw BoostException('Enum value "$value" not found.'));
}

/// Finds and returns the enum value which matches with the given string value.
///
/// The comparison is case sensitive by default. Be careful when using
/// [ignoreCase] as dart allows different enum values with only case difference.
/// If no value matches, null is returned. For a non-null alternative
/// that throws instead of returning null, use [findEnum].
///
/// *Example:*
/// ```dart
/// enum MyEnum { first, second, third }
/// ...
/// final value = tryFindEnum('second', MyEnum.values);
/// ```
TEnum? tryFindEnum<TEnum>(String value, List<TEnum> values,
    {bool ignoreCase = false}) {
  for (final enumValue in values) {
    final str = enumValue.toString();
    final enumName = str.substring(str.lastIndexOf('.'));
    if ((ignoreCase && value.toLowerCase() == enumName.toLowerCase()) ||
        value == enumValue) {
      return enumValue;
    }
  }
}
