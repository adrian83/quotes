import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/tools/strings.dart';

const fieldAuthorName = "name";
const fieldAuthorDescription = "description";

class Author extends Entity {
  String name;
  String? description;

  Author(String? id, this.name, this.description, DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Author.fromJson(Map<String, dynamic> json)
      : this(
            json[fieldEntityId],
            json[fieldAuthorName],
            json[fieldAuthorDescription],
            DateTime.parse(json[fieldModifiedUtc]),
            DateTime.parse(json[fieldCreatedUtc]));

  List<String> get descriptionParts => description?.split("\n") ?? [];
  String? get shortDescription => shorten(description, 250);

  @override
  Map toJson() => super.toJson()
    ..addAll({fieldAuthorName: name, fieldAuthorDescription: description});
}

JsonDecoder<Author> _authorJsonDecoder =
    (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(PageInfo(0, 0, 0), []);

  AuthorsPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_authorJsonDecoder, json);
}
