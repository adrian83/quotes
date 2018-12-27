import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../route_paths.dart';

@Component(
  selector: 'new-quote',
  templateUrl: 'new_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService)
  ],
  directives: const [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class NewQuoteComponent extends ErrorHandler
    with Navigable
    implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final Router _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  NewQuoteComponent(
      this._authorService, this._bookService, this._quoteService, this._router);

  Quote get quote => _quote;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _quote.authorId = _author.id)
      .then((_) => _bookService.get(_author.id, param(bookIdParam, state)))
      .then((book) => _book = book)
      .then((_) => _quote.bookId = _book.id)
      .catchError(handleError);

  void save() => _quoteService
      .create(quote)
      .then((quote) => _quote = quote)
      .then((_) => _editQuote(_quote))
      .catchError(handleError);

  void _editQuote(Quote quote) =>
      _router.navigate(editQuoteUrl(quote.authorId, quote.bookId, quote.id));

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(search(), "search")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), _author.name));

    if (_book.id == null) return elems;
    elems.add(
        Breadcrumb.link(showBookUrl(_author.id, _book.id), _book.title).last());

    return elems;
  }
}
