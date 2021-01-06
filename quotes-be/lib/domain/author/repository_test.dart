import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../../infrastructure/elasticsearch/store.dart';
import '../../infrastructure/elasticsearch/response.dart';

import '../common/model.dart';
import 'model.dart';
import 'repository.dart';

class AuthorStoreMock extends Mock implements ESStore<Author> {}

void main() {
  var authorStore = AuthorStoreMock();

  var authorRepository = AuthorRepository(authorStore);

  var authorId = "abcd-efgh";

  var author = Author(authorId, "John", "Great writter", DateTime.now().toUtc(), DateTime.now().toUtc());

  var authorGetResult = GetResult("authors", "author", author.id, 1, true, {});

  var searchPhrase = "test";

  var pageRequest = PageRequest(5, 0);

  var searchReq = SearchEntityRequest(null, pageRequest.offset, pageRequest.limit);

  var pageParams = {"limit": pageRequest.limit, "offset": pageRequest.offset, "phrase": searchPhrase};

  var authorsCount = 15;

  void assertAuthor(Author expected, Author actual) {
    expect(expected.id, equals(actual.id));
    expect(expected.name, equals(actual.name));
    expect(expected.description, equals(actual.description));
    //expect(expected.modifiedUtc, equals(actual.modifiedUtc));
    //expect(expected.createdUtc, equals(actual.createdUtc));
  }

  test("save should persist author entity", () async {
    when(authorStore.index(author)).thenAnswer((_) => Future.value());

    await authorRepository.save(author);

    verify(authorStore.index(author));
  });

  test("save should return failed Future if authors store throws exception", () async {
    when(authorStore.index(author)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.save(author), throwsStateError);

    verify(authorStore.index(author));
  });

  test("find should return author entity", () async {
    when(authorStore.get(authorId)).thenAnswer((_) => Future.value(authorGetResult));

    var result = await authorRepository.find(authorId);

    verify(authorStore.get(authorId));

    assertAuthor(author, result);
  });

// TODO: update those tests

/*
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
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams)).thenAnswer((_) => Future.value(PostgreSQLResultMock()));

    when(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {})).thenAnswer((_) => Future.value(PostgreSQLResultMock()));

    var result = await authorRepository.findAuthors(searchReq);

    verify(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verify(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));

    expect(result.info.limit, equals(searchReq.pageRequest.limit));
    expect(result.info.offset, equals(searchReq.pageRequest.offset));
    expect(result.info.total, equals(authorsCount));
  });

  test("findAuthors should return failed Future if getting authors fails", () async {
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams))
        .thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.findAuthors(searchReq), throwsStateError);

    verifyNever(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verifyNever(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));
  });

  test("findAuthors should return failed Future if getting authors count fails", () async {
    when(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams)).thenAnswer((_) => Future.value(PostgreSQLResultMock()));

    when(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {})).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorRepository.findAuthors(searchReq), throwsStateError);

    verify(postgreSQLConnectionMock.query(findAuthorsStmt(searchPhrase), substitutionValues: pageParams));

    verifyNever(postgreSQLConnectionMock.query(findAuthorsCountStmt(searchPhrase), substitutionValues: {}));
  });
  */
}
