import '../../../domain/author/model.dart';
import '../../../infrastructure/web/param.dart';
import '../../../infrastructure/web/form.dart';

const authorIdLabel = "authorId";
const limitLabel = "limit";
const offsetLabel = "offset";

class PersistAuthorParams {
  String? name, description;

  PersistAuthorParams(Map form, Params params) {
    this.name = form[authorNameLabel];
    this.description = form[authorDescLabel];
  }

  Author toAuthor() {
    List<Violation> violations = [];

    var nameOrError = notEmptyString(authorNameLabel, this.name);
    nameOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString(authorDescLabel, this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Author.create(nameOrError.e1!, descriptionOrError.e1!);
  }
}

class UpdateAuthorParams extends PersistAuthorParams {
  String? authorId;

  UpdateAuthorParams(Map form, Params params)
      : this.authorId = params.getValue(authorIdLabel),
        super(form, params);

  Author toAuthor() {
    List<Violation> violations = [];

    var nameOrError = notEmptyString(authorNameLabel, this.name);
    nameOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString(authorDescLabel, this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Author.update(authorId!, nameOrError.e1!, descriptionOrError.e1!);
  }
}

class FindAuthorParams {
  String? authorId;

  FindAuthorParams(Params params) {
    this.authorId = params.getValue(authorIdLabel);
  }

  String getAuthorId() {
    List<Violation> violations = [];

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return locationOrError.e1!;
  }
}

class DeleteAuthorParams extends FindAuthorParams {
  DeleteAuthorParams(Params params) : super(params);
}

class ListAuthorsParams {
  String? limit, offset;

  ListAuthorsParams(Params params) {
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
  }

  ListAuthorsRequest toListAuthorsRequest() {
    List<Violation> violations = [];

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListAuthorsRequest(pageDataOrError.e1!, pageDataOrError.e2!);
  }
}

class ListEventsByAuthorParams {
  String? authorId, quoteId, limit, offset;

  ListEventsByAuthorParams(Params params) {
    this.authorId = params.getValue(authorIdLabel);
    this.limit = params.getValue(limitLabel);
    this.offset = params.getValue(offsetLabel);
  }

  ListEventsByAuthorRequest toListEventsByAuthorRequest() {
    List<Violation> violations = [];

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return ListEventsByAuthorRequest(locationOrError.e1!, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}
