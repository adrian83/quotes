import 'package:uuid/uuid.dart';

import '../../common/json.dart';

const idLabel = 'id';
const modifiedUtcLabel = 'modifiedUtc';
const createdUtcLabel = 'createdUtc';

const eventIdLabel = 'eventId';
const operationLabel = 'operation';
const entityLabel = 'entity';

class Entity implements Jsonable {
  String id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.create() : this(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  @override
  Map toJson() =>
      {idLabel: id, createdUtcLabel: createdUtc.toIso8601String(), modifiedUtcLabel: modifiedUtc.toIso8601String()};

  @override
  String toString() => "Entity [$idLabel: $id, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class Event<T extends Entity> extends Entity {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String operation;
  T entity;

  Event(String id, this.operation, this.entity, DateTime modifiedUtc, DateTime createdUtc) : super.create();

  @override
  Map toJson() => super.toJson()..addAll({operationLabel: operation, entityLabel: entity.toJson()});

  @override
  String toString() =>
      "Event [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, " +
      "$createdUtcLabel: $createdUtc, $entityLabel: $entity]";
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

  Map toJson() => {
        "limit": limit,
        "offset": offset,
        "total": total,
      };

  @override
  String toString() => "PageInfo [limit: $limit, offset: $offset, total: $total]";
}

class Page<T extends Jsonable> {
  PageInfo info;
  List<T> elements;

  Page(this.info, this.elements);

  Map toJson() => {
        "info": info.toJson(),
        "elements": elements.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "Page [info: $info, elements: $elements]";
}

class SearchEntityRequest {
  String? searchPhrase;
  late PageRequest pageRequest;

  SearchEntityRequest(this.searchPhrase, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "SearchEntityRequest [searchPhrase: $searchPhrase, pageRequest: $pageRequest]";
}
