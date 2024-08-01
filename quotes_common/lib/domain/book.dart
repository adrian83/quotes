import 'package:quotes_common/util/strings.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/page.dart';

const fieldBookTitle = "title";
const fieldBookDescription = "description";
const fieldBookAuthorId = "authorId";

const _shortDescriptionMaxLen = 250;

class Book extends Entity {
  final String _title, _authorId;
  final String? _description;

  Book(String id, this._title, this._description, this._authorId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Book.fromJson(Map<String, dynamic> json)
      : this(json[fieldEntityId], json[fieldBookTitle], json[fieldBookDescription], json[fieldBookAuthorId], DateTime.parse(json[fieldEntityModifiedUtc]),
            DateTime.parse(json[fieldEntityCreatedUtc]));

  String get title => _title;
  String get authorId => _authorId;
  String? get description => _description;

  List<String> get descriptionParts => _description?.split("\n") ?? [];
  String? get shortDescription => shorten(_description, _shortDescriptionMaxLen);

  @override
  Map toJson() => super.toJson()..addAll({fieldBookTitle: _title, fieldBookAuthorId: _authorId, fieldBookDescription: _description});
}

JsonDecoder<Book> _bookJsonDecoder = (Map<String, dynamic> json) => Book.fromJson(json);

class BooksPage extends Page<Book> {
  BooksPage(super.info, super.elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), []);

  BooksPage.fromJson(Map<String, dynamic> json) : super.fromJson(_bookJsonDecoder, json);
}
