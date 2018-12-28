import 'package:angular_router/angular_router.dart';

import '../../route_paths.dart';

const missing = "-";

class QuotesRouter {
  final Router _router;

  QuotesRouter(this._router);

  void createAuthor() => _router.navigate(createAuthorUrl());

  void showAuthor(authorId) => _router.navigate(showAuthorUrl(authorId));

  void editAuthor(authorId) => _router.navigate(editAuthorUrl(authorId));

  void showAuthorEvents(authorId) =>
      _router.navigate(authorEventsUrl(authorId));

  // -----

  void createBook(authorId) => _router.navigate(createBookUrl(authorId));

  void showBook(String authorId, String bookId) =>
      _router.navigate(showBookUrl(authorId, bookId));

  void editBook(String authorId, String bookId) =>
      _router.navigate(editBookUrl(authorId, bookId));

  void showBookEvents(String authorId, String bookId) =>
      _router.navigate(bookEventsUrl(authorId, bookId));

  // -----

  void createQuote(String authorId, String bookId) =>
      _router.navigate(createQuoteUrl(authorId, bookId));

  void showQuote(String authorId, String bookId, String quoteId) =>
      _router.navigate(showQuoteUrl(authorId, bookId, quoteId));

  void editQuote(String authorId, String bookId, String quoteId) =>
      _router.navigate(editQuoteUrl(authorId, bookId, quoteId));

  void showQuoteEvents(String authorId, String bookId, String quoteId) =>
      _router.navigate(quoteEventsUrl(authorId, bookId, quoteId));

  // -----

  String param(String name, RouterState state) => state.parameters[name];

  // -----

  String search() => RoutePaths.search.toUrl();

  String showAuthorUrl(String authorId) =>
      RoutePaths.showAuthor.toUrl(parameters: _mapFromParams1(authorId));

  String editAuthorUrl(String authorId) =>
      RoutePaths.editAuthor.toUrl(parameters: _mapFromParams1(authorId));

  String createAuthorUrl() => RoutePaths.newAuthor.toUrl();

  String authorEventsUrl(String authorId) =>
      RoutePaths.authorEvents.toUrl(parameters: _mapFromParams1(authorId));

  String createBookUrl(String authorId) =>
      RoutePaths.newBook.toUrl(parameters: _mapFromParams1(authorId));

  String showBookUrl(String authorId, String bookId) =>
      RoutePaths.showBook.toUrl(parameters: _mapFromParams2(authorId, bookId));

  String editBookUrl(String authorId, String bookId) =>
      RoutePaths.editBook.toUrl(parameters: _mapFromParams2(authorId, bookId));

  String bookEventsUrl(String authorId, String bookId) =>
      RoutePaths.bookEvents.toUrl(parameters: _mapFromParams2(authorId, bookId));

  String showQuoteUrl(String authorId, String bookId, String quoteId) =>
      RoutePaths.showQuote
          .toUrl(parameters: _mapFromParams3(authorId, bookId, quoteId));

  String createQuoteUrl(String authorId, String bookId) =>
      RoutePaths.newQuote.toUrl(parameters: _mapFromParams2(authorId, bookId));

  String editQuoteUrl(String authorId, String bookId, String quoteId) =>
      RoutePaths.editQuote
          .toUrl(parameters: _mapFromParams3(authorId, bookId, quoteId));

  String quoteEventsUrl(String authorId, String bookId, String quoteId) =>
      RoutePaths.quoteEvents
          .toUrl(parameters: _mapFromParams3(authorId, bookId, quoteId));

  Map<String, String> _mapFromParams1(String authorId) =>
      {authorIdParam: authorId ?? missing};

  Map<String, String> _mapFromParams2(String authorId, String bookId) =>
      {authorIdParam: authorId ?? missing, bookIdParam: bookId ?? missing};

  Map<String, String> _mapFromParams3(
          String authorId, String bookId, String quoteId) =>
      {
        authorIdParam: authorId ?? missing,
        bookIdParam: bookId ?? missing,
        quoteIdParam: quoteId ?? missing
      };
}
