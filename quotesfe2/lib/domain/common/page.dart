import 'dart:convert';

class PageInfo {
  int limit, offset, total;

  PageInfo(this.limit, this.offset, this.total);

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(json['limit'], json['offset'], json['total']);

  int get curent {
    var current = offset / limit;
    return current.isNaN ? 0 : current.ceil();
  }

  Map toJson() => {
        "limit": limit,
        "offset": offset,
        "total": total,
      };

  @override
  String toString() => jsonEncode(this);
}

typedef JsonDecoder<T> = T Function(Map<String, dynamic> json);

class Page<T> {
  late PageInfo info;
  late List<T> elements;

  Page(this.info, this.elements);

  Page.fromJson(JsonDecoder<T> decoder, Map<String, dynamic> json) {
    var jsonElems = json['elements'] as List;
    elements = jsonElems.map((j) => decoder(j)).toList();
    info = PageInfo.fromJson(json['info']);
  }

  bool get empty => elements.isEmpty;
  T? get first => empty ? null : elements[0];

  set last(T? elem) {
    if (elem == null) {
      return;
    }

    elements.add(elem);
  }

@override
  String toString() => jsonEncode(this);
}

const defPageSize = 3;

class PageRequest {
  int limit, offset;

  PageRequest(this.limit, this.offset);

  PageRequest.page(int pageNumber) : this(defPageSize, defPageSize * pageNumber);

  PageRequest.pageWithSize(int pageNumber, int size) : this(size, size * pageNumber);

@override
  String toString() => jsonEncode(this);
}
