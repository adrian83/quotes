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
import '../../tools/strings.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';

@Component(
  selector: 'edit-quote',
  templateUrl: 'edit_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class EditQuoteComponent implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();
  String _oldText = "";

  EditQuoteComponent(this._authorService, this._bookService, this._quoteService,
      this._errorHandler, this._router);

  Quote get quote => _quote;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.find(_author.id, bookId))
      .then((book) => _book = book)
      .then((_) => _router.param(quoteIdParam, state))
      .then((quoteId) => _quoteService.find(_author.id, _book.id, quoteId))
      .then((quote) => _quote = quote)
      .then((_) => _oldText = _quote.text)
      .catchError(_errorHandler.handleError);

  void update() => _quoteService
      .update(_quote)
      .then((quote) => _quote = quote)
      .then((_) => _errorHandler.showInfo("Quote '${_quote.text}' updated"))
      .then((_) => _oldText = _quote.text)
      .catchError(_errorHandler.handleError);

  void showQuote() =>
      _router.showQuote(_quote.authorId, _quote.bookId, _quote.id);

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
      var url = _router.showQuoteUrl(_author.id, _book.id, _quote.id);
      elems.add(Breadcrumb.link(url, shorten(_oldText, 20)));
    }
    return elems;
  }
}
