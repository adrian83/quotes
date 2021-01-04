import '../../web/param.dart';
import '../../web/form.dart';
import '../../../common/tuple.dart';
import '../../../domain/book/model.dart';

var minTitleLen = 1;
var maxTitleLen = 200;
var invalidTitleViolation = Violation("title", "Title length should be between $minTitleLen and $maxTitleLen");

var minDescriptionLen = 1;
var maxDescriptionLen = 5000;
var invalidDescViolation = Violation("description", "Description length should be between $minDescriptionLen and $maxDescriptionLen");

class PersistBookParams {
  String? authorId, title, description;

  PersistBookParams(Map form, Params params) {
    this.title = form["title"];
    this.description = form["description"];
    this.authorId = params.getValue("authorId");
  }

  Book toBook() {
    List<Violation> violations = [];

    var titleOrError = notEmptyString("title", this.title);
    titleOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString("description", this.description);
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
      : this.bookId = params.getValue("bookId"),
        super(form, params);

  Book toBook() {
    List<Violation> violations = [];

    var titleOrError = notEmptyString("title", this.title);
    titleOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString("description", this.description);
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
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
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
    this.authorId = params.getValue("authorId");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
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
    this.authorId = params.getValue("authorId");
    this.bookId = params.getValue("bookId");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
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
