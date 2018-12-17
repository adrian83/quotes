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
  void onActivate(_, RouterState state) => _authorService
      .get(param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _bookService.get(_author.id, param(bookIdParam, state)))
      .then((book) => _book = book)
      .then((_) => param(quoteIdParam, state))
      .then((quoteId) => _quoteService.get(_author.id, _book.id, quoteId))
      .then((quote) => _quote = quote)
      .catchError(handleError);

  void editQuote() =>
      _router.navigate(editQuoteUrl(_quote.authorId, _quote.bookId, _quote.id));

  void deleteQuote() => _quoteService
      .delete(quote.authorId, quote.bookId, quote.id)
      .then((_) => showInfo("Quote '${shorten(_quote.text, 20)}' deleted"))
      .then((_) => _quote = Quote.empty())
      .catchError(handleError);

        void showEvents() => _router.navigate(quoteEventsUrl(_author.id, _book.id, _quote.id));

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), _author.name));
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), "books"));

    if (_book.id == null) return elems;
    elems.add(Breadcrumb.link(showBookUrl(_author.id, _book.id), _book.title));
    elems.add(Breadcrumb.link(showBookUrl(_author.id, _book.id), "quotes"));

    if (_quote.id == null) return elems;
    elems.add(Breadcrumb.text(shorten(_quote.text, 20)).last());

    return elems;
  }
}
