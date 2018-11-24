import 'package:angular_router/angular_router.dart';

const authorIdParam = "authorId";
const bookIdParam = "bookId";
const quoteIdParam = "quoteId";

class RoutePaths {
  static final listAuthors = RoutePath(path: 'authors/show');
  static final newAuthor = RoutePath(path: 'authors/new');
  static final showAuthor = RoutePath(path: 'authors/show/:$authorIdParam');
  static final editAuthor = RoutePath(path: 'authors/edit/:$authorIdParam');
  static final authorEvents = RoutePath(path: 'authors/events/:$authorIdParam');

  static final showBook =
      RoutePath(path: 'authors/show/:$authorIdParam/books/show/:$bookIdParam');
  static final editBook =
      RoutePath(path: 'authors/show/:$authorIdParam/books/edit/:$bookIdParam');
  static final newBook =
      RoutePath(path: 'authors/show/:$authorIdParam/books/new');

  static final showQuote = RoutePath(
      path:
          'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/show/:$quoteIdParam');
  static final editQuote = RoutePath(
      path:
          'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/edit/:$quoteIdParam');
  static final newQuote = RoutePath(
      path: 'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/new');

  static final info = RoutePath(path: 'info');
}
