import 'package:angular_router/angular_router.dart';

const authorIdParam = "authorId";
const bookIdParam = "bookId";
const quoteIdParam = "quoteId";

class RoutePaths {
  static final listAuthorsPath = 'authors/show';
  static final newAuthorPath = 'authors/new';
  static final showAuthorPath = 'authors/show/:$authorIdParam';
  static final editAuthorPath = 'authors/edit/:$authorIdParam';
  static final authorEventsPath = 'authors/events/:$authorIdParam';

  static final listAuthors = RoutePath(path: listAuthorsPath);
  static final newAuthor = RoutePath(path: newAuthorPath);
  static final showAuthor = RoutePath(path: showAuthorPath);
  static final editAuthor = RoutePath(path: editAuthorPath);
  static final authorEvents = RoutePath(path: authorEventsPath);

  static final newBookPath = 'authors/show/:$authorIdParam/books/new';
  static final showBookPath =
      'authors/show/:$authorIdParam/books/show/:$bookIdParam';
  static final editBookPath =
      'authors/show/:$authorIdParam/books/edit/:$bookIdParam';
  static final bookEventsPath =
      'authors/show/:$authorIdParam/books/events/:$bookIdParam';

  static final newBook = RoutePath(path: newBookPath);
  static final showBook = RoutePath(path: showBookPath);
  static final editBook = RoutePath(path: editBookPath);
  static final bookEvents = RoutePath(path: bookEventsPath);

  static final newQuotePath =
      'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/new';
  static final showQuotePath =
      'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/show/:$quoteIdParam';
  static final editQuotePath =
      'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/edit/:$quoteIdParam';
  static final quoteEventsPath =
      'authors/show/:$authorIdParam/books/show/:$bookIdParam/quotes/events/:$quoteIdParam';

  static final newQuote = RoutePath(path: newQuotePath);
  static final showQuote = RoutePath(path: showQuotePath);
  static final editQuote = RoutePath(path: editQuotePath);
  static final quoteEvents = RoutePath(path: quoteEventsPath);

  static final info = RoutePath(path: 'info');
}
