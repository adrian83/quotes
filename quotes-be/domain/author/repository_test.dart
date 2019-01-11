import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:postgres/postgres.dart';

import 'service.dart';
import '../book/event.dart';
import '../book/repository.dart';
import '../common/model.dart';
import '../quote/event.dart';
import '../quote/repository.dart';
import 'event.dart';
import 'model.dart';
import 'repository.dart';

class PostgreSQLConnectionMock extends Mock implements PostgreSQLConnection {}

void main() {
  var postgreSQLConnectionMock = PostgreSQLConnectionMock();

  var authorRepository = AuthorRepository(postgreSQLConnectionMock);

  var authorId = "abcd-efgh";

  var author = Author(authorId, "John", "Great writter", DateTime.now().toUtc(),
      DateTime.now().toUtc());

  var authorRow = [
    authorId,
    "John",
    "Great writter",
    DateTime.now().toUtc(),
    DateTime.now().toUtc()
  ];

  var insertAuthorParams = {
    "id": author.id,
    "name": author.name,
    "desc": author.description,
    "modified": author.modifiedUtc,
    "created": author.createdUtc
  };

  test("save should persist author entity", () async {
    when(postgreSQLConnectionMock.execute(insertAuthorStmt,
            substitutionValues: insertAuthorParams))
        .thenAnswer((_) => Future.value());

    await authorRepository.save(author);

    verify(postgreSQLConnectionMock.execute(insertAuthorStmt,
        substitutionValues: insertAuthorParams));
  });

  test("save should return failed Future if db driver throws exception",
      () async {
    when(postgreSQLConnectionMock.execute(insertAuthorStmt,
            substitutionValues: insertAuthorParams))
        .thenThrow(StateError("exception"));

    expect(() => authorRepository.save(author), throwsStateError);

    verify(postgreSQLConnectionMock.execute(insertAuthorStmt,
        substitutionValues: insertAuthorParams));
  });

  test("find should return author entity", () async {
    when(postgreSQLConnectionMock
            .query(getAuthorStmt, substitutionValues: {"id": authorId}))
        .thenAnswer((_) => Future.value([authorRow]));

    var result = await authorRepository.find(authorId);

    verify(postgreSQLConnectionMock
        .query(getAuthorStmt, substitutionValues: {"id": authorId}));

    expect(result.id, equals(author.id));
  });

  test("find should return failed Future id db driver throws exception",
      () async {
    when(postgreSQLConnectionMock
            .query(getAuthorStmt, substitutionValues: {"id": authorId}))
        .thenThrow(StateError("exception"));

    expect(() => authorRepository.find(authorId), throwsStateError);

    verify(postgreSQLConnectionMock
        .query(getAuthorStmt, substitutionValues: {"id": authorId}));
  });
}
