DateTime nowUtc() => DateTime.now().toUtc();

const fieldEntityId = "id";
const fieldModifiedUtc = "modifiedUtc";
const fieldCreatedUtc = "createdUtc";

class Entity {
  String? id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.empty() : this(null, nowUtc(), nowUtc());

  Map toJson() => {
        fieldEntityId: id,
        fieldModifiedUtc: modifiedUtc.toIso8601String(),
        fieldCreatedUtc: createdUtc.toIso8601String()
      };
}
