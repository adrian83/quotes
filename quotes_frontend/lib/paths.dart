import 'package:quotes_frontend/domain/common/service.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/domain/quote.dart';

// AUTHORS

const String authorCreatePathPattern = r'^/authors/new/?(&[\w-=]+)?$';
const String authorUpdatePathPattern = r'^/authors/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String authorShowPathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String authorDeletePathPattern = r'^/authors/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String authorEventsPathPattern = r'^/authors/events/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

String createAuthorPath() => "/authors/new/";

String showAuthorPath(Author author) => "/authors/show/${author.id}";

String deleteAuthorPath(Author author) => "/authors/delete/${author.id}";

String updateAuthorPath(Author author) => "/authors/update/${author.id}";

String listAuthorEventsPath(Author author) => "/authors/events/${author.id}";

// BOOKS

const String bookDeletePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String bookEventsPathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/events/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String bookCreatePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/new/?(&[\w-=]+)?$';
const String bookShowPathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String bookUpdatePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

String createBookPath(String authorId) => "/authors/show/$authorId/books/new/";

String showBookPath(Book book) => "/authors/show/${book.authorId}/books/show/${book.id}";

String deleteBookPath(Book book) => "/authors/show/${book.authorId}/books/delete/${book.id}";

String updateBookPath(Book book) => "/authors/show/${book.authorId}/books/update/${book.id}";

String listBookEventsPath(Book book) => '/authors/show/${book.authorId}/books/events/${book.id}';

// QUOTES

const String quoteDeletePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String quoteEventsPathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/events/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String quoteCreatePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/new/?(&[\w-=]+)?$';
const String quoteShowPathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';
const String quoteUpdatePathPattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

String createQuotePath(String authorId, String bookId) => "/authors/show/$authorId/books/show/$bookId/quotes/new/";

String showQuotePath(Quote quote) => "/authors/show/${quote.authorId}/books/show/${quote.bookId}/quotes/show/${quote.id}";

String deleteQuotePath(Quote quote) => "/authors/show/${quote.authorId}/books/show/${quote.bookId}/quotes/delete/${quote.id}";

String updateQuotePath(Quote quote) => "/authors/show/${quote.authorId}/books/show/${quote.bookId}/quotes/update/${quote.id}";

String listQuoteEventsPath(Quote quote) => "/authors/show/${quote.authorId}/books/show/${quote.bookId}/quotes/events/${quote.id}";

// SEARCH

const String searchPathPattern = r'^/search/?(&[\w-=]+)?$';

String searchPath(String searchPhrase) => "/search/?$paramSearchPhrase=$searchPhrase";
