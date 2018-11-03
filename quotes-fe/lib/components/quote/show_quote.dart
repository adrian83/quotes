import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/pagination.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../routes.dart';

import '../../tools/strings.dart';

@Component(
  selector: 'show-quote',
  templateUrl: 'show_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService)
  ],
  directives: const [coreDirectives, Breadcrumbs, Events, Pagination],
)
class ShowQuoteComponent extends ErrorHandler with Navigable, OnActivate {
  static final Logger logger = Logger('ShowQuoteComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final Router _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  ShowQuoteComponent(
      this._authorService, this._bookService, this._quoteService, this._router);

  Quote get quote => _quote;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    var quoteId = current.parameters[quoteIdParam];
    logger.info("Show quote with id: $quoteId");

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .catchError(handleError);

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .catchError(handleError);

    _quoteService
        .get(authorId, bookId, quoteId)
        .then((quote) => _quote = quote)
        .catchError(handleError);
  }

  void editQuote() =>
      _router.navigate(editQuoteUrl(_quote.authorId, _quote.bookId, _quote.id));

  void deleteQuote() => _quoteService
      .delete(quote.authorId, quote.bookId, quote.id)
      .then((_) => showInfo("Quote '${shorten(_quote.text, 20)}' deleted"))
      .then((_) => _quote = Quote.empty())
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_author.id), _author.name),
        Breadcrumb.link(showAuthorUrl(_author.id), "books"),
        Breadcrumb.link(showBookUrl(_author.id, _book.id), _book.title),
        Breadcrumb.link(showBookUrl(_author.id, _book.id), "quotes"),
        Breadcrumb.text(shorten(_quote.text, 20)).last(),
      ];
}
