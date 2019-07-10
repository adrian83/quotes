import '../common/exception.dart';
import '../common/form.dart';
import '../common/params.dart';

class AuthorIdValidParams {
  String _authorId;

  AuthorIdValidParams(this._authorId);

  String get authorId => _authorId;
}

class AuthorIdParams {
  ParseElem<String> _authorId;

  AuthorIdParams(this._authorId);

  AuthorIdValidParams validate() {
    var fields = [_authorId];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return AuthorIdValidParams(_authorId.value);
  }

  ParseElem<String> get authorId => _authorId;
}

class ListByAuthorValidParams extends PageValidParams {
  String _authorId;

  ListByAuthorValidParams(this._authorId, int limit, int offset) : super(limit, offset);

  String get authorId => _authorId;
}

class ListByAuthorParams extends PageParams {
  ParseElem<String> _authorId;

  ListByAuthorParams(this._authorId, ParseElem<int> limit, ParseElem<int> offset) : super(limit, offset);

  ListByAuthorValidParams validate() {
    var fields = [_authorId, limit, offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return ListByAuthorValidParams(_authorId.value, limit.value, offset.value);
  }

  ParseElem<String> get authorId => _authorId;
}
