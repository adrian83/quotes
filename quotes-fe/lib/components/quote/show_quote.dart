import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../routes.dart';
import '../../tools/strings.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'show-quote',
  templateUrl: 'show_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter)
  ],
  directives: const [coreDirectives, Breadcrumbs, Events, Pagination],
)
class ShowQuoteComponent extends ErrorHandler with OnActivate {
  static final Logger logger = Logger('ShowQuoteComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final QuotesRouter _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  ShowQuoteComponent(
      this._authorService, this._bookService, this._quoteService, this._router);

  Quote get quote => _quote;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.get(_author.id, bookId))
      .then((book) => _book = book)
      .then((_) => _router.param(quoteIdParam, state))
      .then((quoteId) => _quoteService.get(_author.id, _book.id, quoteId))
      .then((quote) => _quote = quote)
      .catchError(handleError);

  void editQuote() =>
      _router.editQuote(_quote.authorId, _quote.bookId, _quote.id);

  void deleteQuote() => _quoteService
      .delete(quote.authorId, quote.bookId, quote.id)
      .then((_) => showInfo("Quote '${shorten(_quote.text, 20)}' deleted"))
      .then((_) => _quote = Quote.empty())
      .catchError(handleError);

  void showEvents() => _router.showQuoteEvents(_author.id, _book.id, _quote.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _author.name));
    }

    if (_book.id != null) {
      var url = _router.showBookUrl(_author.id, _book.id);
      elems.add(Breadcrumb.link(url, _book.title));
    }

    if (_quote.id != null) {
      elems.add(Breadcrumb.text(shorten(_quote.text, 20)).last());
    }

    return elems;
  }
}
