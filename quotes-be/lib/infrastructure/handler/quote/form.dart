import '../../../domain/quote/model.dart';
import '../../web/param.dart';
import '../../web/form.dart';

var minTextLen = 1;
var maxTextLen = 5000;
var invalidTextViolation = Violation("text", "Text length should be between $minTextLen and $maxTextLen");

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

    var locationOrError = validateBookLocation(authorId, bookId);
    locationOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Quote.create(
      textOrError.e1!,
      locationOrError.e1!,
      locationOrError.e2!,
    );
  }
}

class UpdateQuoteParams extends PersistQuoteParams {
  String? quoteId;

  UpdateQuoteParams(Map form, Params params)
      : this.quoteId = params.getValue("quoteId"),
        super(form, params);

  Quote toQuote() {
    List<Violation> violations = [];

    var textOrError = notEmptyString("text", this.text);
    textOrError.ifElem2Exists((err) => violations.add(err));

    var locationOrError = validateQuoteLocation(authorId, bookId, quoteId);
    locationOrError.ifElem4Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Quote.update(
      locationOrError.e3!,
      textOrError.e1!,
      locationOrError.e1!,
      locationOrError.e2!,
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

    var locationOrError = validateQuoteLocation(authorId, bookId, quoteId);
    locationOrError.ifElem4Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return locationOrError.e3!;
  }
}

class DeleteQuoteParams extends FindQuoteParams {
  DeleteQuoteParams(Params params) : super(params);
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

    var locationOrError = validateQuoteLocation(authorId, bookId, quoteId);
    locationOrError.ifElem4Exists((vls) => violations.addAll(vls));

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListEventsByQuoteRequest(locationOrError.e1!, locationOrError.e2!, locationOrError.e3!, pageDataOrError.e1!, pageDataOrError.e2!);
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

    var locationOrError = validateBookLocation(authorId, bookId);
    locationOrError.ifElem3Exists((vls) => violations.addAll(vls));

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListQuotesFromBookRequest(locationOrError.e1!, locationOrError.e2!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}
