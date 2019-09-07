
class Tuple1<T1> {
  T1 _e1;

  Tuple1(this._e1);

  T1 get e1 => _e1;
}

class Tuple2<T1, T2> extends Tuple1<T1> {
  T2 _e2;

  Tuple2(T1 e1, this._e2): super(e1);

  T2 get e2 => _e2;
}
