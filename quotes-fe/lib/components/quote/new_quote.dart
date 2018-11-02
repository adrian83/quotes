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

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    _quote.authorId = authorId;
    _quote.bookId = bookId;

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .catchError(handleError);

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .catchError(handleError);
  }

  Quote get quote => _quote;

  void save() => _quoteService
      .create(quote)
      .then((quote) => _quote = quote)
      .then((_) => _editQuote(_quote))
      .catchError(handleError);

  void _editQuote(Quote quote) =>
      _router.navigate(editQuoteUrl(quote.authorId, quote.bookId, quote.id));

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_book.authorId), _author.name),
        Breadcrumb.link(showAuthorUrl(_book.authorId), "books"),
        Breadcrumb.link(showBookUrl(_book.authorId, _book.id), _book.title)
            .last(),
      ];
}
