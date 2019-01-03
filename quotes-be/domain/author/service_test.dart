import 'dart:io';

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

  test(
      "exception in save method in AuthorRepository should prevent from executing save on AuthorEventRepository and result with failed Future",
      () async {
    when(authorRepositoryMock.save(author)).thenThrow(StateError("exception"));

    expect(() => authorService.save(author), throwsStateError);

    verify(authorRepositoryMock.save(author));
    verifyNever(authorEventRepositoryMock.save(author));
  });

  test(
      "exception in save method in AuthorEventRepository should result with failed Future",
      () async {
    when(authorRepositoryMock.save(author)).thenThrow(StateError("exception"));

    expect(() => authorService.save(author), throwsStateError);

    verify(authorRepositoryMock.save(author));
    verifyNever(authorEventRepositoryMock.save(author));
  });
}
