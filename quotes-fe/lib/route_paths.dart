import 'package:angular_router/angular_router.dart';

const authorIdParam = "authorId";
const bookIdParam = "bookId";
const quoteIdParam = "quoteId";

class RoutePaths {
  static final listAuthors = RoutePath(path: 'authors');
  static final newAuthor = RoutePath(path: '${listAuthors.path}/new');
  static final showAuthor =
      RoutePath(path: '${listAuthors.path}/show/:$authorIdParam');
  static final editAuthor =
      RoutePath(path: '${listAuthors.path}/edit/:$authorIdParam');

  static final showBook = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/show/:$bookIdParam');
  static final editBook = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/edit/:$bookIdParam');
  static final newBook = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/new');

  static final showQuote = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/show/:$bookIdParam/quotes/show/:$quoteIdParam');
  static final editQuote = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/show/:$bookIdParam/quotes/edit/:$quoteIdParam');
  static final newQuote = RoutePath(
      path:
          '${listAuthors.path}/show/:$authorIdParam/books/show/:$bookIdParam/quotes/new');


  static final info = RoutePath(path: 'info');
}
