import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'param.dart';
import '../../common/tuple.dart';
import '../../domain/common/model.dart';

abstract class FormParser<T> {
  Tuple2<T, List<Violation>> parse(Map rawForm);
}

bool exists(Object? o) => o != null;
bool isString(Object? o) => exists(o) && o is String;
bool empty(String? str) => str == null || str.length == 0;
bool shorter(String str, int limit) => str.length < limit;
bool longer(String str, int limit) => str.length > limit;

Future<Map> readForm<F>(HttpRequest req) =>
    req.toList().then((lol) => lol.map((l) => String.fromCharCodes(l))).then((los) => los.join()).then((content) => jsonDecode(content) as Map);

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

Tuple2<String, List<Violation>> validateAuthorLocation(String? authorId) {
  List<Violation> violations = [];

  var authorIdOrError = notEmptyString("authorId", authorId);
  authorIdOrError.ifElem2Exists((err) => violations.add(err));

  if (violations.isNotEmpty) {
    return Tuple2<String, List<Violation>>(null, violations);
  }

  return Tuple2<String, List<Violation>>(authorIdOrError.e1!, violations);
}

Tuple3<String, String, List<Violation>> validateBookLocation(String? authorId, String? bookId) {
  List<Violation> violations = [];

  var authorIdOrError = notEmptyString("authorId", authorId);
  authorIdOrError.ifElem2Exists((err) => violations.add(err));

  var bookIdOrError = notEmptyString("bookId", bookId);
  bookIdOrError.ifElem2Exists((err) => violations.add(err));

  if (violations.isNotEmpty) {
    return Tuple3<String, String, List<Violation>>(null, null, violations);
  }

  return Tuple3<String, String, List<Violation>>(authorIdOrError.e1!, bookIdOrError.e1!, violations);
}

Tuple4<String, String, String, List<Violation>> validateQuoteLocation(String? authorId, String? bookId, String? quoteId) {
  List<Violation> violations = [];

  var authorIdOrError = notEmptyString("authorId", authorId);
  authorIdOrError.ifElem2Exists((err) => violations.add(err));

  var bookIdOrError = notEmptyString("bookId", bookId);
  bookIdOrError.ifElem2Exists((err) => violations.add(err));

  var quoteIdOrError = notEmptyString("quoteId", quoteId);
  quoteIdOrError.ifElem2Exists((err) => violations.add(err));

  if (violations.isNotEmpty) {
    return Tuple4<String, String, String, List<Violation>>(null, null, null, violations);
  }

  return Tuple4<String, String, String, List<Violation>>(authorIdOrError.e1!, bookIdOrError.e1!, quoteIdOrError.e1!, violations);
}

Tuple3<int, int, List<Violation>> validatePageRequest(String? offset, String? limit) {
  List<Violation> violations = [];

  var limitOrError = positiveInteger("limit", limit);
  limitOrError.ifElem2Exists((err) => violations.add(err));

  var offsetOrError = positiveInteger("offset", offset);
  offsetOrError.ifElem2Exists((err) => violations.add(err));

  if (violations.isNotEmpty) {
    return Tuple3<int, int, List<Violation>>(null, null, violations);
  }

  return Tuple3<int, int, List<Violation>>(offsetOrError.e1!, limitOrError.e1!, violations);
}

class SearchParams {
  String? phrase, limit, offset;

  SearchParams(Params params) {
    this.phrase = params.getValue("searchPhrase");
    this.limit = params.getValue("limit");
    this.offset = params.getValue("offset");
  }

  SearchEntityRequest toSearchEntityRequest() {
    List<Violation> violations = [];

    var pageDataOrError = validatePageRequest(offset, limit);
    pageDataOrError.ifElem3Exists((vls) => violations.addAll(vls));

    if (violations.isNotEmpty) {
      throw InvalidInputException(violations);
    }

    return SearchEntityRequest(this.phrase, pageDataOrError.e1!, pageDataOrError.e2!);
  }
}
