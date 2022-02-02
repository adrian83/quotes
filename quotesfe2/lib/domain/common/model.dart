DateTime nowUtc() => DateTime.now().toUtc();

class Entity {
  String? id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.empty() : this(null, nowUtc(), nowUtc());

  Map toJson() => {"id": id, "modifiedUtc": modifiedUtc.toIso8601String(), "createdUtc": createdUtc.toIso8601String()};
}
