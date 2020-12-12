
import '../../../common/tuple.dart';
import '../../../domain/quote/model.dart';
import '../../web/param.dart';



var minTextLen = 1;
var maxTextLen = 5000;
var invalidTextViolation = Violation("text", "Text length should be between $minTextLen and $maxTextLen");

Tuple2<String, Violation> notEmptyString(String name, String? value) {
  if (value == null) {
    var violation = Violation(name, "$name cannot be empty");
    return Tuple2<String, Violation>(null, violation);
  }

  String text = value.toString().trim();
  if (text.length == 0) {
    var violation = Violation(name, "$name cannot be empty");
    return Tuple2<String, Violation>(null, violation);
  }

  return Tuple2<String, Violation>(text, null);
}

Tuple2<int, Violation> positiveInteger(String name, String? value) {
  if (value == null) {
    var violation = Violation(name, "$name cannot be empty");
    return Tuple2<int, Violation>(null, violation);
  }

  var intVal = int.parse(value.toString().trim());
  if (intVal < 0) {
    var violation = Violation(name, "$name must be zero or grater than zero");
    return Tuple2<int, Violation>(null, violation);
  }

  return Tuple2<int, Violation>(intVal, null);
}

class PersistQuoteParams {
  String? authorId, bookId, text;
  
  PersistQuoteParams(Map form, Params params) {
    this.text = form["text"];
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
  }

  Quote toQuote() {
    List<Violation> violations = [];

    var textOrError = notEmptyString("text", this.text);
    textOrError.ifElem2Exists((err) => violations.add(err));

    var authorIdOrError = notEmptyString("authorId", this.authorId);
    authorIdOrError.ifElem2Exists((err) => violations.add(err));

        var bookIdOrError = notEmptyString("bookId", this.bookId);
    bookIdOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return Quote.create(
        textOrError.e1!,
        authorIdOrError.e1!,
        bookIdOrError.e1!,
      );
  }
}

class UpdateQuoteParams extends PersistQuoteParams{
  String? quoteId;
  
  UpdateQuoteParams(Map form, Params params) :
    this.quoteId = params.getValue("quoteId"),
    super(form, params);
  

  Quote toQuote() {
    List<Violation> violations = [];

    var textOrError = notEmptyString("text", this.text);
    textOrError.ifElem2Exists((err) => violations.add(err));

    var authorIdOrError = notEmptyString("authorId", this.authorId);
    authorIdOrError.ifElem2Exists((err) => violations.add(err));

        var bookIdOrError = notEmptyString("bookId", this.bookId);
    bookIdOrError.ifElem2Exists((err) => violations.add(err));

        var quoteIdOrError = notEmptyString("quoteId", this.quoteId);
    quoteIdOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return Quote.update(quoteIdOrError.e1!,
        textOrError.e1!,
        authorIdOrError.e1!,
        bookIdOrError.e1!,
      );
  }
}

class FindQuoteParams {
  String? authorId, bookId, quoteId;
  
  FindQuoteParams(Params params) {
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
    this.quoteId = params.getValue("quoteId");
  }

  String getQuoteId() {
    List<Violation> violations = [];

    var authorIdOrError = notEmptyString("authorId", this.authorId);
    authorIdOrError.ifElem2Exists((err) => violations.add(err));

        var bookIdOrError = notEmptyString("bookId", this.bookId);
    bookIdOrError.ifElem2Exists((err) => violations.add(err));

    var quoteIdOrError = notEmptyString("quoteId", this.quoteId);
    quoteIdOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return quoteIdOrError.e1!;
  }
}

class DeleteQuoteParams extends FindQuoteParams {

  DeleteQuoteParams(Params params) : super(params);
}

class SearchQuotesParams {
  String? phrase, limit, offset; 

  SearchQuotesParams(Map form, Params params) {
    this.phrase = params.getValue("searchPhrase");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
  }

  SearchQuoteRequest toSearchQuoteRequest() {
    List<Violation> violations = [];

        var limitOrError = positiveInteger("limit", this.limit);
    limitOrError.ifElem2Exists((err) => violations.add(err));

        var offsetOrError = positiveInteger("offset", this.offset);
    offsetOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return SearchQuoteRequest(this.phrase, offsetOrError.e1!, limitOrError.e1!);
}
}

class ListEventsByQuoteParams {
  String? authorId, bookId, quoteId, limit, offset;

 ListEventsByQuoteParams(Params params) {
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
    this.quoteId = params.getValue("quoteId");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
 }

  ListEventsByQuoteRequest toListEventsByQuoteRequest() {
        List<Violation> violations = [];

    var authorIdOrError = notEmptyString("authorId", this.authorId);
    authorIdOrError.ifElem2Exists((err) => violations.add(err));

        var bookIdOrError = notEmptyString("bookId", this.bookId);
    bookIdOrError.ifElem2Exists((err) => violations.add(err));

    var quoteIdOrError = notEmptyString("quoteId", this.quoteId);
    quoteIdOrError.ifElem2Exists((err) => violations.add(err));

        var limitOrError = positiveInteger("limit", this.limit);
    limitOrError.ifElem2Exists((err) => violations.add(err));

        var offsetOrError = positiveInteger("offset", this.offset);
    offsetOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return ListEventsByQuoteRequest(authorIdOrError.e1!, bookIdOrError.e1!, quoteIdOrError.e1!, offsetOrError.e1!, limitOrError.e1!);
  }
}

class ListQuotesFromBookParams {
  String? authorId, bookId, limit, offset;

 ListQuotesFromBookParams(Params params) {
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
 }

  ListQuotesFromBookRequest toListQuotesFromBookRequest() {
        List<Violation> violations = [];

    var authorIdOrError = notEmptyString("authorId", this.authorId);
    authorIdOrError.ifElem2Exists((err) => violations.add(err));

        var bookIdOrError = notEmptyString("bookId", this.bookId);
    bookIdOrError.ifElem2Exists((err) => violations.add(err));

        var limitOrError = positiveInteger("limit", this.limit);
    limitOrError.ifElem2Exists((err) => violations.add(err));

        var offsetOrError = positiveInteger("offset", this.offset);
    offsetOrError.ifElem2Exists((err) => violations.add(err));

    if(violations.isNotEmpty){
      throw InvalidInputException(violations);
    }

    return ListQuotesFromBookRequest(authorIdOrError.e1!, bookIdOrError.e1!, offsetOrError.e1!, limitOrError.e1!);
  }
}