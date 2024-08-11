import "package:test/test.dart";
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:quotesbe/domain/author/model/command.dart';
import 'package:quotesbe/domain/author/repository.dart';
import 'package:quotesbe/domain/author/service.dart';
import 'package:quotesbe/domain/book/repository.dart';
import 'package:quotesbe/domain/quote/repository.dart';
import 'package:quotesbe/domain/author/service_test.mocks.dart';

@GenerateMocks([
  AuthorRepository,
  AuthorEventRepository,
  BookRepository,
  BookEventRepository,
  QuoteRepository,
  QuoteEventRepository,
])
void main() {
  test("save should persist author entity and author event", () async {
    // given
    var authorRepoMock = MockAuthorRepository();
    var authorEventRepoMock = MockAuthorEventRepository();
    var bookRepoMock = MockBookRepository();
    var bookEventRepoMock = MockBookEventRepository();
    var quoteRepoMock = MockQuoteRepository();
    var quoteEventRepoMock = MockQuoteEventRepository();

    var authorService = AuthorService(
      authorRepoMock,
      authorEventRepoMock,
      bookRepoMock,
      bookEventRepoMock,
      quoteRepoMock,
      quoteEventRepoMock,
    );

    when(authorRepoMock.save(any)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.save(any)).thenAnswer((_) => Future.value());

    var command = NewAuthorCommand("John", "This is John");

    // when
    var result = await authorService.save(command);

    // then
    verify(authorRepoMock.save(any));
    verify(authorEventRepoMock.storeSaveAuthorEvent(any));

    expect(result.name, equals(command.name));
    expect(result.description, equals(command.description));
  });

  test("exception in save method in AuthorRepository should result with failed Future", () async {
    // given
    var authorRepoMock = MockAuthorRepository();
    var authorEventRepoMock = MockAuthorEventRepository();
    var bookRepoMock = MockBookRepository();
    var bookEventRepoMock = MockBookEventRepository();
    var quoteRepoMock = MockQuoteRepository();
    var quoteEventRepoMock = MockQuoteEventRepository();

    var authorService = AuthorService(
      authorRepoMock,
      authorEventRepoMock,
      bookRepoMock,
      bookEventRepoMock,
      quoteRepoMock,
      quoteEventRepoMock,
    );

    var command = NewAuthorCommand("John", "This is John");

    when(authorRepoMock.save(any)).thenAnswer((_) => Future.error(StateError("exception")));

    // when, then
    expect(authorService.save(command), throwsStateError);

    verify(authorRepoMock.save(any));
    verifyNever(authorEventRepoMock.save(any));
  });

  test("exception in save method in AuthorEventRepository should result with failed Future", () async {
    // given
    var authorRepoMock = MockAuthorRepository();
    var authorEventRepoMock = MockAuthorEventRepository();
    var bookRepoMock = MockBookRepository();
    var bookEventRepoMock = MockBookEventRepository();
    var quoteRepoMock = MockQuoteRepository();
    var quoteEventRepoMock = MockQuoteEventRepository();

    var authorService = AuthorService(
      authorRepoMock,
      authorEventRepoMock,
      bookRepoMock,
      bookEventRepoMock,
      quoteRepoMock,
      quoteEventRepoMock,
    );

    var command = NewAuthorCommand("John", "This is John");

    when(authorRepoMock.save(any)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.storeSaveAuthorEvent(any)).thenAnswer((_) => Future.error(StateError("exception")));

    // when, then
    expect(authorService.save(command), throwsStateError);

    verify(authorRepoMock.save(any));
    verifyNever(authorEventRepoMock.save(any));
  });
/*
  test("find should find author", () async {
    when(authorRepoMock.find(authorId)).thenAnswer((_) => Future.value(author));

    var result = await authorService.find(authorId);

    verify(authorRepoMock.find(authorId));

    expect(result.id, equals(author.id));
  });

  test("exception in find method in AuthorEventRepository should result with failed Future", () async {
    when(authorRepoMock.find(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.find(authorId), throwsStateError);

    verify(authorRepoMock.find(authorId));
  });

  test("update should update author entity and author event", () async {
    when(authorRepoMock.update(author)).thenAnswer((_) => Future.value(author));
    when(authorEventRepoMock.update(author)).thenAnswer((_) => Future.value(author));

    var result = await authorService.update(author);

    verify(authorRepoMock.update(author));
    verify(authorEventRepoMock.update(author));

    expect(result.id, equals(author.id));
  });

  test("exception in update method in AuthorRepository should result with failed Future", () async {
    when(authorRepoMock.update(author)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.update(author), throwsStateError);

    verify(authorRepoMock.update(author));
    verifyNever(authorEventRepoMock.update(author));
  });

  test("exception in update method in AuthorEventRepository should result with failed Future", () async {
    when(authorRepoMock.update(author)).thenAnswer((_) => Future.value(author));
    when(authorEventRepoMock.update(author)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.update(author), throwsStateError);

    verify(authorRepoMock.update(author));
    verifyNever(authorEventRepoMock.update(author));
  });

  test("findAuthors should return authors page", () async {
    var phrase = "Shakespeare";
    var pageReq = PageRequest(1, 5);
    var searchReq = SearchEntityRequest(phrase, pageReq.offset, pageReq.limit);
    var authorsPage = Page<Author>(PageInfo(1, 5, 345), [author]);

    when(authorRepoMock.findAuthors(searchReq)).thenAnswer((_) => Future.value(authorsPage));

    var result = await authorService.findAuthors(searchReq);

    verify(authorRepoMock.findAuthors(searchReq));

    expect(result.elements.length, equals(1));
  });

  test("exception in findAuthors method in AuthorRepository should result with failed Future", () async {
    var phrase = "Shakespeare";
    var pageReq = PageRequest(1, 5);
    var searchReq = SearchEntityRequest(phrase, pageReq.offset, pageReq.limit);

    when(authorRepoMock.findAuthors(searchReq)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.findAuthors(searchReq), throwsStateError);

    verify(authorRepoMock.findAuthors(searchReq));
  });

  test("listEvents should return author event page", () async {
    var pageReq = PageRequest(1, 5);
    var listReq = ListEventsByAuthorRequest(authorId, pageReq.offset, pageReq.limit);
    var eventsPage = Page<AuthorEvent>(PageInfo(1, 5, 345), [createAuthorEvent]);

    when(authorEventRepoMock.listEvents(listReq)).thenAnswer((_) => Future.value(eventsPage));

    var result = await authorService.listEvents(listReq);

    verify(authorEventRepoMock.listEvents(listReq));

    expect(result.elements.length, equals(1));
  });

  test("exception in listEvents method in AuthorEventRepository should result with failed Future", () async {
    var pageReq = PageRequest(1, 5);
    var listReq = ListEventsByAuthorRequest(authorId, pageReq.offset, pageReq.limit);

    when(authorEventRepoMock.listEvents(listReq)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.listEvents(listReq), throwsStateError);

    verify(authorEventRepoMock.listEvents(listReq));
  });

  test("delete should delete author", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(bookRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(bookEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(quoteRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(quoteEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());

    await authorService.delete(authorId);

    verify(authorRepoMock.delete(authorId));
    verify(authorEventRepoMock.delete(authorId));
    verify(bookRepoMock.deleteByAuthor(authorId));
    verify(bookEventRepoMock.deleteByAuthor(authorId));
    verify(quoteRepoMock.deleteByAuthor(authorId));
    verify(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in delete method in AuthorRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verifyNever(authorEventRepoMock.delete(authorId));
    verifyNever(bookRepoMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in delete method in AuthorEventRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verifyNever(authorEventRepoMock.delete(authorId));
    verifyNever(bookRepoMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in deleteByAuthor method in BookRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(bookRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verify(authorEventRepoMock.delete(authorId));
    verifyNever(bookRepoMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in deleteByAuthor method in BookEventRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(bookRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(bookEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verify(authorEventRepoMock.delete(authorId));
    verify(bookRepoMock.deleteByAuthor(authorId));
    verifyNever(bookEventRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in deleteByAuthor method in QuoteRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(bookRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(bookEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(quoteRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verify(authorEventRepoMock.delete(authorId));
    verify(bookRepoMock.deleteByAuthor(authorId));
    verify(bookEventRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });

  test("exception in deleteByAuthor method in QuoteEventRepository should result with failed Future", () async {
    when(authorRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(authorEventRepoMock.delete(authorId)).thenAnswer((_) => Future.value());
    when(bookRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(bookEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(quoteRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.value());
    when(quoteEventRepoMock.deleteByAuthor(authorId)).thenAnswer((_) => Future.error(StateError("exception")));

    expect(authorService.delete(authorId), throwsStateError);

    verify(authorRepoMock.delete(authorId));
    verify(authorEventRepoMock.delete(authorId));
    verify(bookRepoMock.deleteByAuthor(authorId));
    verify(bookEventRepoMock.deleteByAuthor(authorId));
    verify(quoteRepoMock.deleteByAuthor(authorId));
    verifyNever(quoteEventRepoMock.deleteByAuthor(authorId));
  });
  */
}
