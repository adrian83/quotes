import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:postgres/postgres.dart';

import '../common/model.dart';
import 'model.dart';
import 'repository.dart';

class PostgreSQLConnectionMock extends Mock implements PostgreSQLConnection {}

void main() {
  var postgreSQLConnectionMock = PostgreSQLConnectionMock();

  var authorRepository = AuthorRepository(postgreSQLConnectionMock);

  var authorId = "abcd-efgh";

  var author = Author(authorId, "John", "Great writter", DateTime.now().toUtc(), DateTime.now().toUtc());

  var authorRow = [authorId, "John", "Great writter", DateTime.now().toUtc(), DateTime.now().toUtc()];

  var insertAuthorParams = {"id": author.id, "name": author.name, "desc": author.description, "modified": author.modifiedUtc, "created": author.createdUtc};

  var updateAuthorParams = {"name": author.name, "desc": author.description, "modified": author.modifiedUtc};

  var searchPhrase = "test";

  var searchReq = PageRequest(5, 0);

  var pageParams = {"limit": searchReq.limit, "offset": searchReq.offset, "phrase": searchPhrase};

  var authorsCount = 15;

  void assertAuthor(Author expected, Author actual) {
    expect(expected.id, equals(actual.id));
    expect(expected.name, equals(actual.name));
    expect(expected.description, equals(actual.description));
    //expect(expected.modifiedUtc, equals(actual.modifiedUtc));
    //expect(expected.createdUtc, equals(actual.createdUtc));
  }

  test("save should persist author entity", () async {
    when(postgreSQLConnectionMock.execute(insertAuthorStmt, substitutionValues: insertAuthorParams)).thenAnswer((_) => Future.value());

    await authorRepository.save(author);

    verify(postgreSQLConnectionMock.execute(insertAuthorStmt, substitutionValues: insertAuthorParams));
  });

  test("save should return failed Future if db driver throws exception", () async {
    when(postgreSQLConnectionMock.execute(insertAuthorStmt, substitutionValues: insertAuthorParams)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.save(author), throwsStateError);

    verify(postgreSQLConnectionMock.execute(insertAuthorStmt, substitutionValues: insertAuthorParams));
  });

  test("find should return author entity", () async {
    when(postgreSQLConnectionMock.query(getAuthorStmt, substitutionValues: {"id": authorId})).thenAnswer((_) => Future.value([authorRow]));

    var result = await authorRepository.find(authorId);

    verify(postgreSQLConnectionMock.query(getAuthorStmt, substitutionValues: {"id": authorId}));

    assertAuthor(author, result);
  });

  test("find should return failed Future if db driver throws exception", () async {
    when(postgreSQLConnectionMock.query(getAuthorStmt, substitutionValues: {"id": authorId})).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.find(authorId), throwsStateError);

    verify(postgreSQLConnectionMock.query(getAuthorStmt, substitutionValues: {"id": authorId}));
  });

  test("update should update and return author entity", () async {
    when(postgreSQLConnectionMock.execute(updateAuthorStmt, substitutionValues: updateAuthorParams)).thenAnswer((_) => Future.value());

    var result = await authorRepository.update(author);

    verify(postgreSQLConnectionMock.execute(updateAuthorStmt, substitutionValues: updateAuthorParams));

    assertAuthor(author, result);
  });

  test("update should return failed Future if db driver throws exception", () async {
    when(postgreSQLConnectionMock.execute(updateAuthorStmt, substitutionValues: updateAuthorParams)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.update(author), throwsStateError);

    verify(postgreSQLConnectionMock.execute(updateAuthorStmt, substitutionValues: updateAuthorParams));
  });

  test("delete should delete author entity", () async {
    when(postgreSQLConnectionMock.execute(deleteAuthorStmt, substitutionValues: {"id": authorId})).thenAnswer((_) => Future.value());

    await authorRepository.delete(authorId);

    verify(postgreSQLConnectionMock.execute(deleteAuthorStmt, substitutionValues: {"id": authorId}));
  });

  test("delete should return failed Future if db driver throws exception", () async {
    when(postgreSQLConnectionMock.execute(deleteAuthorStmt, substitutionValues: {"id": authorId})).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.delete(authorId), throwsStateError);

    verify(postgreSQLConnectionMock.execute(deleteAuthorStmt, substitutionValues: {"id": authorId}));
  });

  test("findAuthors should return authors page", () async {
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams)).thenAnswer((_) => Future.value([authorRow]));

    when(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {})).thenAnswer((_) => Future.value([
          [authorsCount]
        ]));

    var result = await authorRepository.findAuthors(searchPhrase, searchReq);

    verify(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verify(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));

    expect(result.info.limit, equals(searchReq.limit));
    expect(result.info.offset, equals(searchReq.offset));
    expect(result.info.total, equals(authorsCount));
  });

  test("findAuthors should return failed Future if getting authors fails", () async {
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams))
        .thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.findAuthors(searchPhrase, searchReq), throwsStateError);

    verifyNever(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verifyNever(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));
  });

  test("findAuthors should return failed Future if getting authors count fails", () async {
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams)).thenAnswer((_) => Future.value([authorRow]));

    when(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {})).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.findAuthors(searchPhrase, searchReq), throwsStateError);

    verify(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verifyNever(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));
  });
}
