import 'dart:convert';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

import 'package:quotesbe2/domain/author/service.dart';
import 'package:quotesbe2/web/error.dart';
import 'package:quotesbe2/web/response.dart';

class AuthorController {
  final Logger _logger = Logger('AuthorController');

  final AuthorService _authorService;

  AuthorController(this._authorService);

  List<ValidationRule> newAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString)
  ];

  List<ValidationRule> updateAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString)
  ];

  Future<Response> search(Request request) async {

    var params = request.url.queryParameters;

    var limitStr = params["limit"];
    var offsetStr = params["offset"]; 

    var phrase = params["searchPhrase"];
    var limit = limitStr != null ? int.parse(limitStr) : 2;
    var offset = offsetStr != null ? int.parse(offsetStr) : 0;

    var query = SearchQuery(phrase, offset, limit);

    return _authorService.findAuthors(query)
        .then((page) => Response.ok(jsonEncode(page)));
  }


  Future<Response> store(Request request) async {
    final String content = await request.readAsString();

    var json = jsonDecode(content) as Map;

    var violations = validate(newAuthorValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[save author] validation error: $violations");
      return responseBadRequest(violations);
    }

    return _authorService
        .save(NewAuthorCommand(json["name"], json["description"]))
        .then((author) => Response.ok(jsonEncode(author)));
  }


  Future<Response> update(Request request, String authorId) async {
    final String content = await request.readAsString();

    var json = jsonDecode(content) as Map;

    var violations = validate(updateAuthorValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[update author] validation error: $violations");
      return responseBadRequest(violations);
    }

    return _authorService
        .update(UpdateAuthorCommand(authorId, json["name"], json["description"]))
        .then((author) => Response.ok(jsonEncode(author)));
  }


  Future<Response> find(Request request, String authorId) =>
      _authorService
          .find(FindAuthorQuery(authorId))
          .then((author) => Response.ok(jsonEncode(author)));


  Future<Response> delete(Request request, String authorId) =>
      _authorService
          .delete(DeleteAuthorQuery(authorId))
          .then((_) => Response.ok(""));
}
