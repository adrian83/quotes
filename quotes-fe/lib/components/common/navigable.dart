import '../../route_paths.dart';

const missing = "-";

class Navigable {
  String listAuthorsUrl() => RoutePaths.listAuthors.toUrl();

  String showAuthorUrl(String authorId) => RoutePaths.showAuthor
      .toUrl(parameters: {authorIdParam: authorId ?? missing});

  String editAuthorUrl(String authorId) => RoutePaths.editAuthor
      .toUrl(parameters: {authorIdParam: authorId ?? missing});

      String createBookUrl(String authorId) =>
          RoutePaths.newBook.toUrl(parameters: {
            authorIdParam: authorId ?? missing
          });

  String showBookUrl(String authorId, String bookId) =>
      RoutePaths.showBook.toUrl(parameters: {
        authorIdParam: authorId ?? missing,
        bookIdParam: bookId ?? missing
      });

  String editBookUrl(String authorId, String bookId) =>
      RoutePaths.editBook.toUrl(parameters: {
        authorIdParam: authorId ?? missing,
        bookIdParam: bookId ?? missing
      });
}
