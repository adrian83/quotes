class Tuple1<T1> {
  T1? e1;

  Tuple1(this.e1);

  void ifElem1Exists(Function(T1) f) {
    if(e1 != null) f(e1!);
  }

  String toString() => "Tuple1 [e1: $e1]";
}

class Tuple2<T1, T2> extends Tuple1<T1> {
  T2? e2;

  Tuple2(T1? e1, this.e2) : super(e1);

  void ifElem2Exists(Function(T2) f) {
    if(e2 != null) f(e2!);
  }

  String toString() => "Tuple2 [e1: $e1, e2: $e2]";
}

class Tuple3<T1, T2, T3> extends Tuple2<T1, T2> {
  T3? e3;

  Tuple3(T1? e1, T2? e2, this.e3) : super(e1, e2);

  String toString() => "Tuple3 [e1: $e1, e2: $e2, e3: $e3]";
}

class Tuple4<T1, T2, T3, T4> extends Tuple3<T1, T2, T3> {
  T4? e4;

  Tuple4(T1? e1, T2? e2, T3? e3, this.e4) : super(e1, e2, e3);

  String toString() => "Tuple4 [e1: $e1, e2: $e2, e3: $e3, e4: $e4]";
}

class Tuple5<T1, T2, T3, T4, T5> extends Tuple4<T1, T2, T3, T4> {
  T5? e5;

  Tuple5(T1? e1, T2? e2, T3? e3, T4? e4, this.e5) : super(e1, e2, e3, e4);

  String toString() => "Tuple5 [e1: $e1, e2: $e2, e3: $e3, e4: $e4, e5: $e5]";
}
