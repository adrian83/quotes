import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/tools/strings.dart';

const fieldQuoteText = "text";
const fieldQuoteAuthorId = "authorId";
const fieldQuoteBookId = "bookId";

class Quote extends Entity {
  String text, authorId, bookId;

  Quote(String? id, this.text, this.authorId, this.bookId, DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Quote.fromJson(Map<String, dynamic> json)
      : this(
            json[fieldEntityId],
            json[fieldQuoteText],
            json[fieldQuoteAuthorId],
            json[fieldQuoteBookId],
            DateTime.parse(json[fieldEntityModifiedUtc]),
            DateTime.parse(json[fieldEntityCreatedUtc]));

  List<String> get textLines => text.split("\n");
  List<String> get shortLines => shorten(text, 80)?.split("\n") ?? [];

  @override
  Map toJson() => super.toJson()
    ..addAll({
      fieldQuoteText: text,
      fieldQuoteAuthorId: authorId,
      fieldQuoteBookId: bookId
    });
}

JsonDecoder<Quote> _quoteJsonDecoder =
    (Map<String, dynamic> json) => Quote.fromJson(json);

class QuotesPage extends Page<Quote> {
  QuotesPage(PageInfo info, List<Quote> elements) : super(info, elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), []);

  QuotesPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_quoteJsonDecoder, json);
}
