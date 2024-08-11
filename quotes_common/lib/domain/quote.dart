import 'package:quotes_common/util/strings.dart';
import 'package:quotes_common/util/time.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/page.dart';

const fieldQuoteText = "text";
const fieldQuoteAuthorId = "authorId";
const fieldQuoteBookId = "bookId";

class Quote extends Entity {
  final String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Quote.fromJson(Map<String, dynamic> json)
      : this(json[fieldEntityId], json[fieldQuoteText], json[fieldQuoteAuthorId], json[fieldQuoteBookId], fromString(json[fieldEntityModifiedUtc]),
            fromString(json[fieldEntityCreatedUtc]));

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  List<String> get textLines => _text.split("\n");
  List<String> get shortLines => shorten(_text, 80)?.split("\n") ?? [];

  @override
  Map toJson() => super.toJson()..addAll({fieldQuoteText: _text, fieldQuoteAuthorId: _authorId, fieldQuoteBookId: _bookId});
}

class QuotesPage extends Page<Quote> {
  QuotesPage(super.info, super.elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), []);

  QuotesPage.fromJson(Map<String, dynamic> json) : super.fromJson(Quote.fromJson, json);
}
