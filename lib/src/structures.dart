/// Structure for holding two values of independent types.
///
/// Tuples are immutable. If tuples are checked for equality,
/// both of the values (a and b) of the tuple are checked for equality.
/// Tuples can be serialized with JsonEncoder.
class Tuple<Ta, Tb> {
  final Ta a;
  final Tb b;

  const Tuple(this.a, this.b);

  Tuple<Ta, Tb> withA(Ta value) => Tuple(value, b);

  Tuple<Ta, Tb> withB(Tb value) => Tuple(a, value);

  @override
  bool operator ==(Object other) {
    if (other is Tuple<Ta, Tb>) {
      return a == other.a && b == other.b;
    }

    return super == other;
  }

  /// Enables tuples to be serialized with JsonEncoder.
  List toJson() => [a, b];

  /// Static factory function that acts like a constructor.
  ///
  /// Useful in case a zipper or combiner delegate is needed.
  /// (For example `Rx.zip2(s1, s2, Tuple.factory)` from rxdart.)
  static Tuple<Ta, Tb> factory<Ta, Tb>(Ta a, Tb b) => Tuple<Ta, Tb>(a, b);
}

/// Structure for holding three values of independent types.
///
/// Triples are immutable. If triples are checked for equality,
/// all of the values (a, b and c) of the triple are checked for equality.
/// Triples can be serialized with JsonEncoder.
class Triple<Ta, Tb, Tc> {
  final Ta a;
  final Tb b;
  final Tc c;

  const Triple(this.a, this.b, this.c);

  Triple<Ta, Tb, Tc> withA(Ta value) => Triple(value, b, c);

  Triple<Ta, Tb, Tc> withB(Tb value) => Triple(a, value, c);

  Triple<Ta, Tb, Tc> withC(Tc value) => Triple(a, b, value);

  @override
  bool operator ==(Object other) {
    if (other is Triple<Ta, Tb, Tc>) {
      return a == other.a && b == other.b && c == other.c;
    }

    return super == other;
  }

  /// Enables triples to be serialized with JsonEncoder.
  List toJson() => [a, b, c];

  /// Static factory function that acts like a constructor.
  ///
  /// Useful in case a zipper or combiner delegate is needed.
  /// (For example `Rx.zip3(s1, s2, s3, Triple.factory)` from rxdart.)
  static Triple<Ta, Tb, Tc> factory<Ta, Tb, Tc>(Ta a, Tb b, Tc c) =>
      Triple<Ta, Tb, Tc>(a, b, c);
}
