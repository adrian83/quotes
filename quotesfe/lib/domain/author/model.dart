import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/tools/strings.dart';

const fieldAuthorName = "name";
const fieldAuthorDescription = "description";

const _shortDescriptionMaxLen = 250;

class Author extends Entity {
  final String _name;
  final String? _description;

  Author(String? id, this._name, this._description, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Author.fromJson(Map<String, dynamic> json)
      : this(json[fieldEntityId], json[fieldAuthorName], json[fieldAuthorDescription], DateTime.parse(json[fieldEntityModifiedUtc]), DateTime.parse(json[fieldEntityCreatedUtc]));

  String get name => _name;
  String? get description => _description;
  List<String> get descriptionParts => description?.split("\n") ?? [];
  String? get shortDescription => shorten(description, _shortDescriptionMaxLen);

  @override
  Map toJson() => super.toJson()..addAll({fieldAuthorName: _name, fieldAuthorDescription: _description});
}

JsonDecoder<Author> _authorJsonDecoder = (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(PageInfo(0, 0, 0), []);

  AuthorsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_authorJsonDecoder, json);
}
