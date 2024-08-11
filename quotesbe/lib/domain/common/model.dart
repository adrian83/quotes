import 'package:quotesbe/storage/elasticsearch/document.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/page.dart';
import 'package:quotes_common/util/time.dart';

const eventIdLabel = 'eventId';
const operationLabel = 'operation';
const entityLabel = 'entity';

const pageRequestLabel = "pageRequest";

const fieldEventId = "id";
const fieldEventOperation = "operation";
const fieldEventEntity = "entity";
const fieldEventEventId = "eventId";

DateTime temporary(dynamic json, String field) {
  var v = json[field];
  return v == null ? DateTime.now() : fromString(v);
}

abstract class EntityDocument extends Entity implements Document {
  EntityDocument(super.id, super.modifiedUtc, super.createdUtc);
}

abstract class Event<T extends EntityDocument> extends EntityDocument {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String operation;
  T entity;

  Event(
    String id,
    this.operation,
    this.entity,
    DateTime modifiedUtc,
    DateTime createdUtc,
  ) : super(id, modifiedUtc, createdUtc);

  @override
  String toString() =>
      "Event [$fieldEntityId: $id, $operationLabel: $operation, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc, $entityLabel: $entity]";
}

class SearchQuery {
  final String? searchPhrase;
  final PageRequest pageRequest;

  SearchQuery(this.searchPhrase, this.pageRequest);

  @override
  String toString() => "SearchQuery [searchPhrase: $searchPhrase, pageRequest: $pageRequest]";
}
