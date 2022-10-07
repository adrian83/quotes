import 'package:quotesfe2/domain/common/page.dart';
import 'package:quotesfe2/domain/common/model.dart';
import 'package:quotesfe2/tools/strings.dart';

class Quote extends Entity {
  String text, authorId, bookId;

  Quote(String? id, this.text, this.authorId, this.bookId, DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Quote.fromJson(Map<String, dynamic> json)
      : this(
            json['id'],
            json['text'],
            json['authorId'],
            json['bookId'],
            DateTime.parse(json["modifiedUtc"]),
            DateTime.parse(json["createdUtc"]));

  List<String> get textLines => text.split("\n");
  List<String> get shortLines => shorten(text, 80)?.split("\n") ?? [];

  @override
  Map toJson() => super.toJson()
    ..addAll({"text": text, "authorId": authorId, "bookId": bookId});
}

JsonDecoder<Quote> _quoteJsonDecoder =
    (Map<String, dynamic> json) => Quote.fromJson(json);

class QuotesPage extends Page<Quote> {
  QuotesPage(PageInfo info, List<Quote> elements) : super(info, elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), []);

  QuotesPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_quoteJsonDecoder, json);
}
