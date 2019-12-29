class Entity {
  String _id;
  DateTime _modifiedUtc, _createdUtc;

  Entity(this._id, this._modifiedUtc, this._createdUtc);

  Entity.empty() : this(null, nowUtc(), nowUtc());

  String get id => _id;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  void set modifiedUtc(DateTime dt) {
    this._modifiedUtc = dt;
  }

  Map toJson() => {"id": _id, "modifiedUtc": _modifiedUtc.toIso8601String(), "createdUtc": _createdUtc.toIso8601String()};
}

DateTime nowUtc() {
  return DateTime.now().toUtc();
}
