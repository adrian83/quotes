import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../common/breadcrumb.dart';
import '../common/events.dart';
import '../common/error_handler.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../route_paths.dart';

@Component(
  selector: 'edit-quote',
  templateUrl: 'edit_quote.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService)
  ],
  directives: const [coreDirectives, formDirectives, Breadcrumbs, Events],
)
class EditQuoteComponent extends ErrorHandler
    with Navigable
    implements OnActivate {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;

  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  EditQuoteComponent(
      this._authorService, this._bookService, this._quoteService);

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

  void update() => _quoteService
      .update(_quote)
      .then((quote) => _quote = quote)
      .then((_) => showInfo("Quote '${_quote.text}' updated"))
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), _author.name));
    elems.add(Breadcrumb.link(showAuthorUrl(_author.id), "books"));

    if (_book.id == null) return elems;
    elems.add(
        Breadcrumb.link(showBookUrl(_author.id, _book.id), _book.title).last());

    return elems;
  }
}
