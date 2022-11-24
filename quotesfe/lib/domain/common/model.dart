DateTime nowUtc() => DateTime.now().toUtc();

const fieldEntityId = "id";
const fieldEntityModifiedUtc = "modifiedUtc";
const fieldEntityCreatedUtc = "createdUtc";

const fieldEventId = "id";
const fieldEventOperation = "operation";
const fieldEventEntity = "entity";
const fieldEventEventId = "eventId";

class Entity {
  String? id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.empty() : this(null, nowUtc(), nowUtc());

  Map toJson() => {
        fieldEntityId: id,
        fieldEntityModifiedUtc: modifiedUtc.toIso8601String(),
        fieldEntityCreatedUtc: createdUtc.toIso8601String()
      };
}
