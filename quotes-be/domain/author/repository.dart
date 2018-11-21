import 'dart:async';

import 'package:postgres/postgres.dart';

import 'model.dart';

import '../common/exception.dart';

class AuthorRepository {
  PostgreSQLConnection _connection;

  AuthorRepository(this._connection);

  Future<void> save(Author author) => _connection.execute(
          "INSERT INTO Author (ID, NAME, DESCRIPTION, CREATED_UTC) VALUES (@id, @name, @desc, @created)",
          substitutionValues: {
            "id": author.id,
            "name": author.name,
            "desc": author.description,
            "created": author.createdUtc
          });

  Future<Author> find(String authorId) {
    return _connection.query("SELECT * FROM Author WHERE id = @id",
        substitutionValues: {"id": authorId}).then((List<List<dynamic>> l) {
      if (l.length == 0) throw FindFailedException();
      var authorData = l[0];

      for(int i = 0; i < authorData.length; i++){
        print("$i  ${authorData[i]} ${authorData[i].runtimeType}\n");
      }

      print(authorData);
      return Author(authorData[0].toString().trim(), authorData[1].toString().trim(), authorData[2].toString().trim(), authorData[3]);
    });
  }
}
