import 'dart:async';

import 'package:postgres/postgres.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const insertAuthorStmt = "INSERT INTO Author (ID, NAME, DESCRIPTION, " +
    "MODIFIED_UTC, CREATED_UTC) VALUES (@id, @name, @desc, " +
    "@modified, @created)";

const updateAuthorStmt = "UPDATE Author SET NAME = @name, " +
    "DESCRIPTION = @desc, MODIFIED_UTC = @modified WHERE ID = @id";

const getAuthorStmt = "SELECT * FROM Author WHERE id = @id";

const deleteAuthorStmt = "DELETE FROM Author WHERE id = @id";

// TODO fix - use prepared statement.
var findAuthorsStmt = (String phrase) =>
    "SELECT * FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION " +
    "ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";

var findAuthorsCountStmt = (String phrase) =>
    "SELECT count(*) FROM Author WHERE NAME ILIKE '%$phrase%' OR " +
    "DESCRIPTION ILIKE '%$phrase%'";

RowDecoder<Author> authorRowDecoder = (List<dynamic> row) => Author.fromDB(row);

class AuthorRepository extends Repository<Author> {
  AuthorRepository(PostgreSQLConnection connection)
      : super(connection, authorRowDecoder);

  Future<void> save(Author author) => saveByStatement(insertAuthorStmt, {
        "id": author.id,
        "name": author.name,
        "desc": author.description,
        "modified": author.modifiedUtc,
        "created": author.createdUtc
      });

  Future<Author> find(String authorId) =>
      findOneByStatement(getAuthorStmt, {"id": authorId});

  Future<Page<Author>> findAuthors(String searchPhrase, PageRequest request) {
    Map<String, Object> params = {
      "limit": request.limit,
      "offset": request.offset,
      "phrase": searchPhrase ?? ""
    };

    return listAll(findAuthorsStmt(params["phrase"]), params).then(
        (List<Author> authors) =>
            count(findAuthorsCountStmt(params["phrase"]), {})
                .then((total) => PageInfo(request.limit, request.offset, total))
                .then((info) => Page(info, authors)));
  }

  Future<Author> update(Author author) => updateAtLeastOne(updateAuthorStmt, {
        "id": author.id,
        "name": author.name,
        "modified": author.modifiedUtc,
        "desc": author.description
      }).then((_) => author);

  Future<void> delete(String authorId) =>
      deleteAtLeastOne(deleteAuthorStmt, {"id": authorId});
}
