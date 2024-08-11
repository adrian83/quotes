import 'package:quotes_common/domain/entity.dart';

const fieldPageInfoLimit = "limit";
const fieldPageInfoOffset = "offset";
const fieldPageInfoTotal = "total";
const fieldPageElements = "elements";
const fieldPageInfo = "info";

const defPageSize = 3;

class PageInfo {
  final int limit, offset, total;

  PageInfo(this.limit, this.offset, this.total);

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(json[fieldPageInfoLimit], json[fieldPageInfoOffset], json[fieldPageInfoTotal]);

  int get curent {
    var current = offset / limit;
    return current.isNaN ? 0 : current.ceil();
  }

  int get pages {
    var pages = total / limit;
    return ((total % limit == 0) ? pages : pages + 1).toInt();
  }

  Map toJson() => {
        fieldPageInfoLimit: limit,
        fieldPageInfoOffset: offset,
        fieldPageInfoTotal: total,
      };

  @override
  String toString() => "PageInfo [limit: $limit, offset: $offset, total: $total]";
}

typedef JsonDecoder<T> = T Function(Map<String, dynamic> json);

class Page<T extends Entity> {
  late final PageInfo info;
  late final List<T> elements;

  Page(this.info, this.elements);

  Page.empty() : this(PageInfo(0, 0, 0), []);

  Page.fromJson(JsonDecoder<T> decoder, Map<String, dynamic> json) {
    var jsonElems = json[fieldPageElements] as List;
    elements = jsonElems.map((j) => decoder(j)).toList();
    info = PageInfo.fromJson(json[fieldPageInfo]);
  }

  bool get empty => elements.isEmpty;
  T? get first => empty ? null : elements[0];

  @override
  String toString() => "Page [info: $info, elements: ${elements.length}]";

  Map<String, dynamic> toJson() => {"info": info.toJson(), "elements": elements.map((e) => e.toJson()).toList()};
}

class PageRequest {
  final int limit, offset;

  PageRequest(this.limit, this.offset);

  PageRequest.page(int pageNumber) : this(defPageSize, defPageSize * pageNumber);

  PageRequest.pageWithSize(int pageNumber, int size) : this(size, size * pageNumber);

  PageRequest.first() : this(1, 0);

  int page() => offset ~/ limit;

  @override
  String toString() => "PageRequest [limit: $limit, offset: $offset]";

  Map toJson() => {"limit": limit, "offset": offset};
}
