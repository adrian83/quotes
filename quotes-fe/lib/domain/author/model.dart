import '../common/page.dart';

import '../../tools/strings.dart';

class Author {
  String _id, _name, _description;

  Author(this._id, this._name, this._description);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json["id"], json["name"], json["description"]);

  factory Author.empty() => Author(null, "", "");

  String get id => _id;
  String get name => _name;
  String get description => _description;
  List<String> get descriptionParts => _description.split("\n");
  String get shortDescription => shorten(_description, 250);

  void set name(String name) {
    this._name = name;
  }

  void set description(String desc) {
    this._description = desc;
  }

  Map toJson() => {"id": _id, "name": _name, "description": _description};
}

class AuthorEvent extends Author {
  String _eventId, _operation;

  AuthorEvent(this._eventId, this._operation, String id, String name,
      String description)
      : super(id, name, description);

  factory AuthorEvent.fromJson(Map<String, dynamic> json) => AuthorEvent(
      json["eventId"],
      json["operation"],
      json["id"],
      json["name"],
      json["description"]);

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() =>
      super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(PageInfo(0, 0, 0), List<Author>());

  factory AuthorsPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var authors = elems.map((j) => Author.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return AuthorsPage(info, authors);
  }
}

class AuthorEventsPage extends Page<AuthorEvent> {
  AuthorEventsPage(PageInfo info, List<AuthorEvent> elements)
      : super(info, elements);

  AuthorEventsPage.empty() : super(PageInfo(0, 0, 0), List<AuthorEvent>());

  factory AuthorEventsPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var authors = elems.map((j) => AuthorEvent.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return AuthorEventsPage(info, authors);
  }
}
