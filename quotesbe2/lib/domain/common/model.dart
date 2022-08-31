import 'package:uuid/uuid.dart';

import 'package:quotesbe2/storage/elasticsearch/document.dart';

const idLabel = 'id';
const modifiedUtcLabel = 'modifiedUtc';
const createdUtcLabel = 'createdUtc';

const eventIdLabel = 'eventId';
const operationLabel = 'operation';
const entityLabel = 'entity';

DateTime nowUtc() => DateTime.now().toUtc();

class Entity extends Document {
  String id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.create() : this(const Uuid().v4(), nowUtc(), nowUtc());

  @override
  Map<dynamic, dynamic> toJson() => {
        idLabel: id,
        createdUtcLabel: createdUtc.toIso8601String(),
        modifiedUtcLabel: modifiedUtc.toIso8601String()
      };

  @override
  String getId() => id;

  @override
  Map toSave() => toJson();

  @override
  Map toUpdate() => toJson();

  @override
  String toString() =>
      "Entity [$idLabel: $id, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

abstract class Event<T extends Entity> extends Entity {
  static final String created = "created",
      modified = "modified",
      deleted = "deleted";

  String operation;
  T entity;

  Event(String id, this.operation, this.entity, DateTime modifiedUtc,
      DateTime createdUtc)
      : super.create();

  @override
  String toString() =>
      "Event [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: $entity]";
}

class PageRequest {
  int limit, offset;

  PageRequest(this.limit, this.offset);
  PageRequest.first() : this(1, 0);

  @override
  String toString() => "PageRequest [limit: $limit, offset: $offset]";
}

class PageInfo {
  int limit, offset, total;

  PageInfo(this.limit, this.offset, this.total);

  Map<dynamic, dynamic> toJson() =>
      {"limit": limit, "offset": offset, "total": total};

  @override
  String toString() =>
      "PageInfo [limit: $limit, offset: $offset, total: $total]";
}

class Page<T extends Document> {
  PageInfo info;
  List<T> elements;

  Page(this.info, this.elements);

  Map<dynamic, dynamic> toJson() => {
        "info": info.toJson(),
        "elements": elements.map((e) => e.toJson()).toList()
      };

  @override
  String toString() => "Page [info: $info, elements: $elements]";
}

class SearchQuery {
  String? searchPhrase;
  late PageRequest pageRequest;

  SearchQuery(this.searchPhrase, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "SearchQuery [searchPhrase: $searchPhrase, pageRequest: $pageRequest]";
}
