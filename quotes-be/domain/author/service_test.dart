import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'service.dart';
import '../book/event.dart';
import '../book/repository.dart';
import '../common/model.dart';
import '../quote/event.dart';
import '../quote/repository.dart';
import 'event.dart';
import 'model.dart';
import 'repository.dart';

class AuthorRepositoryMock extends Mock implements AuthorRepository {}

class AuthorEventRepositoryMock extends Mock implements AuthorEventRepository {}

class BookRepositoryMock extends Mock implements BookRepository {}

class BookEventRepositoryMock extends Mock implements BookEventRepository {}

class QuoteRepositoryMock extends Mock implements QuoteRepository {}

class QuoteEventRepositoryMock extends Mock implements QuoteEventRepository {}

void main() {
  var authorRepositoryMock = AuthorRepositoryMock();
  var authorEventRepositoryMock = AuthorEventRepositoryMock();
  var bookRepositoryMock = BookRepositoryMock();
  var bookEventRepositoryMock = BookEventRepositoryMock();
  var quoteRepositoryMock = QuoteRepositoryMock();
  var quoteEventRepositoryMock = QuoteEventRepositoryMock();

  var authorService = AuthorService(
      authorRepositoryMock,
      authorEventRepositoryMock,
      bookRepositoryMock,
      bookEventRepositoryMock,
      quoteRepositoryMock,
      quoteEventRepositoryMock);

  var author = Author("abc", "John", "Great writter", DateTime.now().toUtc(),
      DateTime.now().toUtc());

  var createAuthorEvent = AuthorEvent.created("abc-def-ghi", author);

  test("save should persiste author entity and author event", () async {
    when(authorRepositoryMock.save(author))
        .thenAnswer((_) => Future.value(author));
    when(authorEventRepositoryMock.save(author))
        .thenAnswer((_) => Future.value(author));

    var result = await authorService.save(author);

    verify(authorRepositoryMock.save(author));
    verify(authorEventRepositoryMock.save(author));

    expect(result.id, equals(author.id));
  });

  test("""exception in save method in AuthorRepository should prevent from executing save on AuthorEventRepository and result with failed Future""",
      () async {
    when(authorRepositoryMock.save(author)).thenThrow(StateError("exception"));

    expect(() => authorService.save(author), throwsStateError);

    verify(authorRepositoryMock.save(author));
    verifyNever(authorEventRepositoryMock.save(author));
  });

  test("""exception in save method in AuthorEventRepository should result with failed Future""", () async {
    when(authorRepositoryMock.save(author))
        .thenAnswer((_) => Future.value(author));
    when(authorRepositoryMock.save(author)).thenThrow(StateError("exception"));

    expect(() => authorService.save(author), throwsStateError);

    verify(authorRepositoryMock.save(author));
    verifyNever(authorEventRepositoryMock.save(author));
  });

  test("find should find author", () async {
    var authorId = "abc";
    when(authorRepositoryMock.find(authorId))
        .thenAnswer((_) => Future.value(author));

    var result = await authorService.find(authorId);

    verify(authorRepositoryMock.find(authorId));

    expect(result.id, equals(author.id));
  });

  test("""exception in find method in AuthorEventRepository should result with failed Future""", () async {
    var authorId = "abc";
    when(authorRepositoryMock.find(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.find(authorId), throwsStateError);

    verify(authorRepositoryMock.find(authorId));
  });

  test("update should update author entity and author event", () async {
    when(authorRepositoryMock.update(author))
        .thenAnswer((_) => Future.value(author));
    when(authorEventRepositoryMock.update(author))
        .thenAnswer((_) => Future.value(author));

    var result = await authorService.update(author);

    verify(authorRepositoryMock.update(author));
    verify(authorEventRepositoryMock.update(author));

    expect(result.id, equals(author.id));
  });

  test("""exception in update method in AuthorRepository should prevent from executing update on AuthorEventRepository and result with failed Future""",
      () async {
    when(authorRepositoryMock.update(author))
        .thenThrow(StateError("exception"));

    expect(() => authorService.update(author), throwsStateError);

    verify(authorRepositoryMock.update(author));
    verifyNever(authorEventRepositoryMock.update(author));
  });

  test("""exception in update method in AuthorEventRepository should result with failed Future""", () async {
    when(authorRepositoryMock.update(author))
        .thenAnswer((_) => Future.value(author));
    when(authorEventRepositoryMock.update(author))
        .thenThrow(StateError("exception"));

    expect(() => authorService.update(author), throwsStateError);

    verify(authorRepositoryMock.update(author));
    verifyNever(authorEventRepositoryMock.update(author));
  });

  test("findAuthors should return authors page", () async {
    var phrase = "Shakespeare";
    var pageReq = PageRequest(1, 5);
    var authorsPage = Page<Author>(PageInfo(1, 5, 345), [author]);

    when(authorRepositoryMock.findAuthors(phrase, pageReq))
        .thenAnswer((_) => Future.value(authorsPage));

    var result = await authorService.findAuthors(phrase, pageReq);

    verify(authorRepositoryMock.findAuthors(phrase, pageReq));

    expect(result.elements.length, equals(1));
  });

  test("""exception in findAuthors method in AuthorRepository should result with failed Future""", () async {
    var phrase = "Shakespeare";
    var pageReq = PageRequest(1, 5);

    when(authorRepositoryMock.findAuthors(phrase, pageReq))
        .thenThrow(StateError("exception"));

    expect(() => authorService.findAuthors(phrase, pageReq), throwsStateError);

    verify(authorRepositoryMock.findAuthors(phrase, pageReq));
  });

  test("listEvents should return author event page", () async {
    var authorId = "abcd-efgh";
    var pageReq = PageRequest(1, 5);
    var eventsPage =
        Page<AuthorEvent>(PageInfo(1, 5, 345), [createAuthorEvent]);

    when(authorEventRepositoryMock.listEvents(authorId, pageReq))
        .thenAnswer((_) => Future.value(eventsPage));

    var result = await authorService.listEvents(authorId, pageReq);

    verify(authorEventRepositoryMock.listEvents(authorId, pageReq));

    expect(result.elements.length, equals(1));
  });

  test("""exception in listEvents method in AuthorEventRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";
    var pageReq = PageRequest(1, 5);

    when(authorEventRepositoryMock.listEvents(authorId, pageReq))
        .thenThrow(StateError("exception"));

    expect(() => authorService.listEvents(authorId, pageReq), throwsStateError);

    verify(authorEventRepositoryMock.listEvents(authorId, pageReq));
  });

  test("delete should delete author", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(bookRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(bookEventRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(quoteRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(quoteEventRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());

    await authorService.delete(authorId);

    verify(authorRepositoryMock.delete(authorId));
    verify(authorEventRepositoryMock.delete(authorId));
    verify(bookRepositoryMock.deleteByAuthor(authorId));
    verify(bookEventRepositoryMock.deleteByAuthor(authorId));
    verify(quoteRepositoryMock.deleteByAuthor(authorId));
    verify(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in delete method in AuthorRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verifyNever(authorEventRepositoryMock.delete(authorId));
    verifyNever(bookRepositoryMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in delete method in AuthorEventRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verifyNever(authorEventRepositoryMock.delete(authorId));
    verifyNever(bookRepositoryMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in deleteByAuthor method in BookRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(bookRepositoryMock.deleteByAuthor(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verify(authorEventRepositoryMock.delete(authorId));
    verifyNever(bookRepositoryMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in deleteByAuthor method in BookEventRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(bookRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(bookEventRepositoryMock.deleteByAuthor(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verify(authorEventRepositoryMock.delete(authorId));
    verify(bookRepositoryMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in deleteByAuthor method in QuoteRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(bookRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(bookEventRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(quoteRepositoryMock.deleteByAuthor(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verify(authorEventRepositoryMock.delete(authorId));
    verify(bookRepositoryMock.deleteByAuthor(authorId));
    verify(bookEventRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });

  test("""exception in deleteByAuthor method in QuoteEventRepository should result with failed Future""", () async {
    var authorId = "abcd-efgh";

    when(authorRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(authorEventRepositoryMock.delete(authorId))
        .thenAnswer((_) => Future.value());
    when(bookRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(bookEventRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(quoteRepositoryMock.deleteByAuthor(authorId))
        .thenAnswer((_) => Future.value());
    when(quoteEventRepositoryMock.deleteByAuthor(authorId))
        .thenThrow(StateError("exception"));

    expect(() => authorService.delete(authorId), throwsStateError);

    verify(authorRepositoryMock.delete(authorId));
    verify(authorEventRepositoryMock.delete(authorId));
    verify(bookRepositoryMock.deleteByAuthor(authorId));
    verify(bookEventRepositoryMock.deleteByAuthor(authorId));
    verify(quoteRepositoryMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepositoryMock.deleteByAuthor(authorId));
  });
}
