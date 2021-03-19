import '../../../domain/quote/model.dart';
import '../../../infrastructure/web/param.dart';
import '../../../infrastructure/web/form.dart';

const quoteIdLabel = "quoteId";
const limitLabel = "limit";
const offsetLabel = "offset";

class PersistQuoteParams {
  String? authorId, bookId;
  late String text;

  PersistQuoteParams(Map form, Params params) {
    this.text = form[quoteTextLabel];
    this.authorId = params.getValue(quoteAuthorIdLabel);
    this.bookId = params.getValue(quoteBookIdLabel);
  }

  Quote toQuote() {
    List<Violation> violations = [];

    var textOrError = notEmptyString(quoteTextLabel, this.text);
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
      : this.quoteId = params.getValue(quoteIdLabel),
        super(form, params);

  Quote toQuote() {
    List<Violation> violations = [];

    var textOrError = notEmptyString(quoteTextLabel, this.text);
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
    this.authorId = params.getValue(quoteAuthorIdLabel);
    this.bookId = params.getValue(quoteBookIdLabel);
    this.quoteId = params.getValue(quoteIdLabel);
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
    this.authorId = params.getValue(quoteAuthorIdLabel);
    this.bookId = params.getValue(quoteBookIdLabel);
    this.quoteId = params.getValue(quoteIdLabel);
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
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

    return ListEventsByQuoteRequest(
        locationOrError.e1!, locationOrError.e2!, locationOrError.e3!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}

class ListQuotesFromBookParams {
  String? authorId, bookId, limit, offset;

  ListQuotesFromBookParams(Params params) {
    this.authorId = params.getValue(quoteAuthorIdLabel);
    this.bookId = params.getValue(quoteBookIdLabel);
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
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

    return ListQuotesFromBookRequest(
        locationOrError.e1!, locationOrError.e2!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}
