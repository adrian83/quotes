import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../route_paths.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';

@Component(
  selector: 'new-quote',
  templateUrl: 'new_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class NewQuoteComponent implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  NewQuoteComponent(this._authorService, this._bookService, this._quoteService, this._errorHandler, this._router);

  Quote get quote => _quote;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _quote.authorId = _author.id)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.find(_author.id, bookId))
      .then((book) => _book = book)
      .then((_) => _quote.bookId = _book.id)
      .catchError(_errorHandler.handleError);

  void save() => _quoteService
      .create(quote)
      .then((quote) => _quote = quote)
      .then((_) => _editQuote(_quote))
      .catchError(_errorHandler.handleError);

  void _editQuote(Quote quote) => _router.editQuote(quote.authorId, quote.bookId, quote.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _author.name));
    }

    if (_book.id != null) {
      var url = _router.showBookUrl(_author.id, _book.id);
      elems.add(Breadcrumb.link(url, _book.title).last());
    }

    return elems;
  }
}
