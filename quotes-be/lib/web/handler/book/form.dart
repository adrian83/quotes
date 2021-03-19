import '../../../domain/book/model.dart';
import '../../../infrastructure/web/param.dart';
import '../../../infrastructure/web/form.dart';

const bookIdLabel = "bookId";
const limitLabel = "limit";
const offsetLabel = "offset";

class PersistBookParams {
  late String? authorId;
  late String title, description;

  PersistBookParams(Map form, Params params) {
    this.title = form[bookTitleLabel];
    this.description = form[bookDescLabel];
    this.authorId = params.getValue(bookAuthorIdLabel);
  }

  Book toBook() {
    List<Violation> violations = [];

    var titleOrError = notEmptyString(bookTitleLabel, this.title);
    titleOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString(bookDescLabel, this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Book.create(titleOrError.e1!, descriptionOrError.e1!, locationOrError.e1!);
  }
}

class UpdateBookParams extends PersistBookParams {
  String? bookId;

  UpdateBookParams(Map form, Params params)
      : this.bookId = params.getValue(bookIdLabel),
        super(form, params);

  Book toBook() {
    List<Violation> violations = [];

    var titleOrError = notEmptyString(bookTitleLabel, this.title);
    titleOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString(bookDescLabel, this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    var locationOrError = validateBookLocation(authorId, bookId);
    locationOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Book.update(locationOrError.e2!, titleOrError.e1!, descriptionOrError.e1!, locationOrError.e1!);
  }
}

class FindBookParams {
  String? authorId, bookId;

  FindBookParams(Params params) {
    this.authorId = params.getValue(bookAuthorIdLabel);
    this.bookId = params.getValue(bookIdLabel);
  }

  String getBookId() {
    List<Violation> violations = [];

    var locationOrError = validateBookLocation(authorId, bookId);
    locationOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return locationOrError.e2!;
  }
}

class DeleteBookParams extends FindBookParams {
  DeleteBookParams(Params params) : super(params);
}

class ListBooksByAuthorParams {
  String? authorId, limit, offset;

  ListBooksByAuthorParams(Params params) {
    this.authorId = params.getValue(bookAuthorIdLabel);
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
  }

  ListBooksByAuthorRequest toListBooksByAuthorRequest() {
    List<Violation> violations = [];

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListBooksByAuthorRequest(locationOrError.e1!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}

class ListEventsByBookParams {
  String? authorId, bookId, limit, offset;

  ListEventsByBookParams(Params params) {
    this.authorId = params.getValue(bookAuthorIdLabel);
    this.bookId = params.getValue(bookIdLabel);
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
  }

  ListEventsByBookRequest toListEventsByBookRequest() {
    List<Violation> violations = [];

    var locationOrError = validateBookLocation(authorId, bookId);
    locationOrError.ifElem3Exists((vls) => violations.addAll(vls));

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListEventsByBookRequest(locationOrError.e1!, locationOrError.e2!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}
