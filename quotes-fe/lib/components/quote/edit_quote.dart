import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
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
  directives: [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class EditQuoteComponent implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author author = Author.empty();
  Book book = Book.empty();
  Quote quote = Quote.empty();
  String _oldText = "";
  List<Event> get events => _errorHandler.events;

  EditQuoteComponent(this._authorService, this._bookService, this._quoteService, this._errorHandler, this._router);

  @override
  void onActivate(_, RouterState state) => _authorService
      .find(_router.param(authorIdParam, state))
      .then((a) => author = a)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.find(author.id, bookId))
      .then((b) => book = b)
      .then((_) => _router.param(quoteIdParam, state))
      .then((quoteId) => _quoteService.find(author.id, book.id, quoteId))
      .then((quote) => quote = quote)
      .then((_) => _oldText = quote.text)
      .catchError(_errorHandler.handleError);

  void update() => _quoteService
      .update(quote)
      .then((q) => quote = q)
      .then((_) => _errorHandler.showInfo("Quote '${quote.text}' updated"))
      .then((_) => _oldText = quote.text)
      .catchError(_errorHandler.handleError);

  void showQuote() => _router.showQuote(quote.authorId, quote.bookId, quote.id);

  List<Breadcrumb> get breadcrumbs {
    return [
      Breadcrumb.link(_router.search(), "search"),
      orElse(author.id, Breadcrumb.link(_router.showAuthorUrl(author.id), author.name)),
      orElse(book.id, Breadcrumb.link(_router.showBookUrl(author.id, book.id), book.title)),
      orElse(quote.id, Breadcrumb.link(_router.showQuoteUrl(author.id, book.id, quote.id), shorten(_oldText, 20)))
    ]..removeWhere((elem) => elem == null);
  }

  T orElse<T, E>(E st, T re) {
    return st == null ? null : re;
  }
}
