import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';

const insertAuthorStmt =
    "INSERT INTO Author (ID, NAME, DESCRIPTION, CREATED_UTC) VALUES (@id, @name, @desc, @created)";
const updateAuthorStmt =
    "UPDATE Author SET NAME = @name, DESCRIPTION = @desc WHERE ID = @id";
const getAuthorStmt = "SELECT * FROM Author WHERE id = @id";
const deleteAuthorStmt = "DELETE FROM Author WHERE id = @id";

class AuthorRepository {
  PostgreSQLConnection _connection;

  AuthorRepository(this._connection);

  Future<void> save(Author author) =>
      _connection.execute(insertAuthorStmt, substitutionValues: {
        "id": author.id,
        "name": author.name,
        "desc": author.description,
        "created": author.createdUtc
      });

  Future<Author> find(String authorId) {
    return _connection.query(getAuthorStmt,
        substitutionValues: {"id": authorId}).then((List<List<dynamic>> l) {
      if (l.length == 0) throw FindFailedException();
      var authorData = l[0];

      for (int i = 0; i < authorData.length; i++) {
        print("$i  ${authorData[i]} ${authorData[i].runtimeType}\n");
      }

      print(authorData);
      return Author.fromDB(authorData);
    });
  }

  Future<Author> update(Author author) =>
      _connection.execute(updateAuthorStmt, substitutionValues: {
        "id": author.id,
        "name": author.name,
        "desc": author.description
      }).then((count) {
        if (count == 0) throw FindFailedException();
        return author;
      });
}
