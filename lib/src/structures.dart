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
}

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
}
