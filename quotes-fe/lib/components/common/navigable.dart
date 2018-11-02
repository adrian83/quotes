import '../../route_paths.dart';

const missing = "-";

class Navigable {
  String listAuthorsUrl() => RoutePaths.listAuthors.toUrl();

  String showAuthorUrl(String authorId) => RoutePaths.showAuthor
      .toUrl(parameters: {authorIdParam: authorId ?? missing});

  String editAuthorUrl(String authorId) => RoutePaths.editAuthor
      .toUrl(parameters: {authorIdParam: authorId ?? missing});

  String createAuthorUrl() => RoutePaths.newAuthor.toUrl();

  String createBookUrl(String authorId) => RoutePaths.newBook
      .toUrl(parameters: {authorIdParam: authorId ?? missing});

  String showBookUrl(String authorId, String bookId) =>
      RoutePaths.showBook.toUrl(parameters: mapFromParams2(authorId, bookId));

  String editBookUrl(String authorId, String bookId) =>
      RoutePaths.editBook.toUrl(parameters: mapFromParams2(authorId, bookId));

  String showQuoteUrl(String authorId, String bookId, String quoteId) =>
      RoutePaths.showQuote
          .toUrl(parameters: mapFromParams3(authorId, bookId, quoteId));

  String createQuoteUrl(String authorId, String bookId) =>
      RoutePaths.newQuote.toUrl(parameters: mapFromParams2(authorId, bookId));

  String editQuoteUrl(String authorId, String bookId, String quoteId) =>
      RoutePaths.editQuote
          .toUrl(parameters: mapFromParams3(authorId, bookId, quoteId));

  Map<String, String> mapFromParams2(String authorId, String bookId) =>
      {authorIdParam: authorId ?? missing, bookIdParam: bookId ?? missing};

  Map<String, String> mapFromParams3(
          String authorId, String bookId, String quoteId) =>
      {
        authorIdParam: authorId ?? missing,
        bookIdParam: bookId ?? missing,
        quoteIdParam: quoteId ?? missing
      };
}
