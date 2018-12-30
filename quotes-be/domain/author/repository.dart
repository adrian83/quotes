import 'dart:async';

import 'package:postgres/postgres.dart';

import '../common/exception.dart';
import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

const insertAuthorStmt =
    "INSERT INTO Author (ID, NAME, DESCRIPTION, MODIFIED_UTC, CREATED_UTC) VALUES (@id, @name, @desc, @modified, @created)";
const updateAuthorStmt =
    "UPDATE Author SET NAME = @name, DESCRIPTION = @desc, MODIFIED_UTC = @modified WHERE ID = @id";
const getAuthorStmt = "SELECT * FROM Author WHERE id = @id";
const deleteAuthorStmt = "DELETE FROM Author WHERE id = @id";
const listAuthorsStmt =
    "SELECT * FROM Author ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";
const searchAuthorsStmt =
    "SELECT * FROM Author WHERE NAME LIKE '%@phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";
const authorsCountStmt = "SELECT count(*) FROM Author";

RowDecoder<Author> authorRowDecoder = (List<dynamic> row) => Author.fromDB(row);

class AuthorRepository extends Repository<Author> {
  AuthorRepository(PostgreSQLConnection connection)
      : super(connection, authorRowDecoder);

  Future<void> save(Author author) => super.saveByStatement(insertAuthorStmt, {
        "id": author.id,
        "name": author.name,
        "desc": author.description,
        "modified": author.modifiedUtc,
        "created": author.createdUtc
      });

  Future<Author> find(String authorId) =>
      super.findOneByStatement(getAuthorStmt, {"id": authorId});

  Future<Page<Author>> findAuthors(String searchPhrase, PageRequest request) {
    var phrase = searchPhrase ?? "";

    Map<String, Object> params = {
      "limit": request.limit,
      "offset": request.offset,
      "phrase": phrase
    };

    // TODO fix - use prepared statement.
    var stmt =
        "SELECT * FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%' ORDER BY CREATED_UTC ASC LIMIT @limit OFFSET @offset";
    var countStmt =
        "SELECT count(*) FROM Author WHERE NAME ILIKE '%$phrase%' OR DESCRIPTION ILIKE '%$phrase%'";

    return connection
        .query(stmt, substitutionValues: params)
        .then((List<List<dynamic>> authorsData) => toEntities(authorsData))
        .then((List<Author> authors) => connection
            .query(countStmt)
            .then((l) => l[0][0])
            .then((total) => PageInfo(request.limit, request.offset, total))
            .then((info) => Page(info, authors)));
  }

  Future<Author> update(Author author) =>
      connection.execute(updateAuthorStmt, substitutionValues: {
        "id": author.id,
        "name": author.name,
        "modified": author.modifiedUtc,
        "desc": author.description
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return author;
      });

  Future<void> delete(String authorId) => connection.execute(deleteAuthorStmt,
          substitutionValues: {"id": authorId}).then((count) {
        if (count == 0) throw FindFailedException();
      });
}
