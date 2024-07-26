import 'dart:math';

import 'package:uuid/uuid.dart';

import 'package:quotesbe/storage/elasticsearch/document.dart';

const idLabel = 'id';
const modifiedUtcLabel = 'modifiedUtc';
const createdUtcLabel = 'createdUtc';

const eventIdLabel = 'eventId';
const operationLabel = 'operation';
const entityLabel = 'entity';

const pageRequestLabel = "pageRequest";

DateTime nowUtc() => DateTime.now().toUtc();

DateTime temporary(dynamic json, String field) {
  var v = json[field];
  return v == null ? DateTime.now() : DateTime.parse(v);
}

class Entity extends Document {
  String id;
  DateTime modifiedUtc, createdUtc;

  Entity(this.id, this.modifiedUtc, this.createdUtc);

  Entity.create() : this(const Uuid().v4(), nowUtc(), nowUtc());

  @override
  Map<dynamic, dynamic> toJson() => {
        idLabel: id,
        createdUtcLabel: createdUtc.toIso8601String(),
        modifiedUtcLabel: modifiedUtc.toIso8601String(),
      };

  @override
  String getId() => id;

  @override
  Map toSave() => toJson();

  @override
  Map toUpdate() => toJson();

  @override
  String toString() => "Entity [$idLabel: $id, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

abstract class Event<T extends Entity> extends Entity {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String operation;
  T entity;

  Event(
    String id,
    this.operation,
    this.entity,
    DateTime modifiedUtc,
    DateTime createdUtc,
  ) : super.create();

  @override
  String toString() => "Event [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: $entity]";
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

  Map<dynamic, dynamic> toJson() => {"limit": limit, "offset": offset, "total": total};

  @override
  String toString() => "PageInfo [limit: $limit, offset: $offset, total: $total]";
}

class Page<T extends Document> {
  PageInfo info;
  List<T> elements;

  Page(this.info, this.elements);

  Page<T> add(Page<T> other) {
    var elems = [...elements, ...other.elements];
    var offset = min(info.offset, other.info.offset);
    var total = max(info.total, other.info.total);
    var limit = info.limit + other.info.limit;
    var inf = PageInfo(limit, offset, total);
    return Page(inf, elems);
  }

  Map<dynamic, dynamic> toJson() => {
        "info": info.toJson(),
        "elements": elements.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "Page [info: $info, elements: $elements]";
}

class SearchQuery {
  final String? searchPhrase;
  final PageRequest pageRequest;

  SearchQuery(this.searchPhrase, this.pageRequest);

  @override
  String toString() => "SearchQuery [searchPhrase: $searchPhrase, pageRequest: $pageRequest]";
}
