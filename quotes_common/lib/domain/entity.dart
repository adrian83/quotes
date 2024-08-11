import 'package:uuid/uuid.dart';

import 'package:quotes_common/util/time.dart';

const fieldEntityId = "id";
const fieldEntityModifiedUtc = "modifiedUtc";
const fieldEntityCreatedUtc = "createdUtc";

const fieldEventId = "id";
const fieldEventOperation = "operation";
const fieldEventEntity = "entity";
const fieldEventEventId = "eventId";

const emptyId = "";

class Entity {
  final String id;
  final DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.empty() : this("", nowUtc(), nowUtc());

  Entity.create() : this(const Uuid().v4(), nowUtc(), nowUtc());

  Map toJson() => {fieldEntityId: id, fieldEntityModifiedUtc: modifiedUtc.toIso8601String(), fieldEntityCreatedUtc: createdUtc.toIso8601String()};
}
