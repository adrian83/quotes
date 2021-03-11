import '../../common/json.dart';

const idF = "id";
const createdUtcF = "createdUtc";
const modifiedUtcF = "modifiedUtc";
const operationF = "operation";
const entityF = "entity";

class Entity implements Jsonable {
  String id;
  DateTime _modifiedUtc, _createdUtc;

  Entity(this.id, this._modifiedUtc, this._createdUtc);

  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  void set modifiedUtc(DateTime md) {
    _modifiedUtc = md;
  }

  Map toJson() => {idF: id, createdUtcF: _createdUtc.toIso8601String(), modifiedUtcF: _modifiedUtc.toIso8601String()};
  
}

class Event<T extends Entity> extends Entity {
  static final String created = "created", modified = "modified", deleted = "deleted";

  String operation;
  T entity;

  Event(String id, this.operation, this.entity, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Map toJson() => super.toJson()..addAll({operationF: operation, entityF: entity.toJson()});
}

class PageRequest {
  int _limit, _offset;

  PageRequest(this._limit, this._offset);

  int get limit => _limit;
  int get offset => _offset;
}

class PageInfo {
  int _limit, _offset, _total;

  PageInfo(this._limit, this._offset, this._total);

  int get limit => _limit;
  int get offset => _offset;
  int get total => _total;

  Map toJson() => {
        "limit": _limit,
        "offset": _offset,
        "total": _total,
      };
}

class Page<T extends Jsonable> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;
  PageInfo get info => _info;

  Map toJson() => {
        "info": _info.toJson(),
        "elements": _elements.map((e) => e.toJson()).toList(),
      };
}

class SearchEntityRequest {
  String? searchPhrase;
  late PageRequest pageRequest;

  SearchEntityRequest(this.searchPhrase, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}
