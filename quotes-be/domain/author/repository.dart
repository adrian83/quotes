import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';
import '../common/model.dart';

const insertAuthorStmt =
    "INSERT INTO Author (ID, NAME, DESCRIPTION, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @name, @desc, @modified, @created)";
const updateAuthorStmt =
    "UPDATE Author SET NAME = @name, DESCRIPTION = @desc, MODIFIED_UTC = @modified WHERE ID = @id";
const getAuthorStmt = "SELECT * FROM Author WHERE id = @id";
const deleteAuthorStmt = "DELETE FROM Author WHERE id = @id";
const listAuthorsStmt = "SELECT * FROM Author LIMIT @limit OFFSET @offset";
const searchAuthorsStmt =
    "SELECT * FROM Author WHERE NAME LIKE '%@phrase%' LIMIT @limit OFFSET @offset"; 
const authorsCountStmt = "SELECT count(*) FROM Author";

class AuthorRepository {
  PostgreSQLConnection _connection;

  AuthorRepository(this._connection);

  Future<void> save(Author author) =>
      _connection.execute(insertAuthorStmt, substitutionValues: {
        "id": author.id,
        "name": author.name,
        "desc": author.description,
        "modified": author.modifiedUtc,
        "created": author.createdUtc
      });

  Future<Author> find(String authorId) => _connection
          .query(getAuthorStmt, substitutionValues: {"id": authorId}).then(
              (List<List<dynamic>> authorsData) {
        if (authorsData.length == 0) throw FindFailedException();
        return Author.fromDB(authorsData[0]);
      });

  Future<Page<Author>> findAuthors(String searchPhrase, PageRequest request) {

    var phrase = searchPhrase ?? "";
    print(phrase);

    Map<String, Object> params = {
      "limit": request.limit,
      "offset": request.offset,
      "phrase": phrase
    };

    // TODO fix - use prepared statement.
    var stmt =
        "SELECT * FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%' LIMIT @limit OFFSET @offset";
    var countStmt = "SELECT count(*) FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%'";

    print(stmt);
    return _connection
        .query(stmt, substitutionValues: params)
        .then((List<List<dynamic>> authorsData) => authorsData
            .map((List<dynamic> authorData) => Author.fromDB(authorData))
            .toList())
        .then((List<Author> authors) => _connection
            .query(countStmt)
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, authors)));
  }

  Future<Author> update(Author author) =>
      _connection.execute(updateAuthorStmt, substitutionValues: {
        "id": author.id,
        "name": author.name,
        "modified": author.modifiedUtc,
        "desc": author.description
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return author;
      });

  Future<void> delete(String authorId) => _connection.execute(deleteAuthorStmt,
          substitutionValues: {"id": authorId}).then((count) {
        if (count == 0) throw FindFailedException();
      });
}
