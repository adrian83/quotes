import 'package:uuid/uuid.dart';

import '../../web/param.dart';
import '../../web/form.dart';

import '../../../domain/author/model.dart';

var minNameLen = 1;
var maxNameLen = 200;
var invalidNameViolation = Violation("name", "Name length should be between $minNameLen and $maxNameLen");

var minDescriptionLen = 1;
var maxDescriptionLen = 5000;
var invalidDescViolation = Violation("description", "Description length should be between $minDescriptionLen and $maxDescriptionLen");

class PersistAuthorParams {
  String? name, description;

  PersistAuthorParams(Map form, Params params) {
    this.name = form["name"];
    this.description = form["description"];
  }

  Author toAuthor() {
    List<Violation> violations = [];

    var nameOrError = notEmptyString("name", this.name);
    nameOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString("description", this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Author(Uuid().v4(), nameOrError.e1!, descriptionOrError.e1!, DateTime.now().toUtc(), DateTime.now().toUtc());
  }
}

class UpdateAuthorParams extends PersistAuthorParams {
  String? authorId;

  UpdateAuthorParams(Map form, Params params)
      : this.authorId = params.getValue("authorId"),
        super(form, params);

  Author toAuthor() {
    List<Violation> violations = [];

    var nameOrError = notEmptyString("name", this.name);
    nameOrError.ifElem2Exists((err) => violations.add(err));

    var descriptionOrError = notEmptyString("description", this.description);
    descriptionOrError.ifElem2Exists((err) => violations.add(err));

    var locationOrError = validateAuthorLocation(authorId);
    locationOrError.ifElem2Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return Author(authorId!, nameOrError.e1!, descriptionOrError.e1!, DateTime.now().toUtc(), DateTime.now().toUtc());
  }
}

class FindAuthorParams {
  String? authorId;

  FindAuthorParams(Params params) {
    this.authorId = params.getValue("authorId");
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
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
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
    this.authorId = params.getValue("authorId");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
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
