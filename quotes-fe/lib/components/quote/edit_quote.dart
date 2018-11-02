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
import '../../routes.dart';

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

  String _oldText = "";
  Author _author = Author.empty();
  Book _book = Book.empty();
  Quote _quote = Quote.empty();

  EditQuoteComponent(
      this._authorService, this._bookService, this._quoteService);

  Quote get quote => _quote;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    var quoteId = current.parameters[quoteIdParam];

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
        .then((_) => _oldText = _quote.text)
        .catchError(handleError);
  }

  void update() => _quoteService
      .update(_quote)
      .then((quote) => _quote = quote)
      .then((_) => showInfo("Quote '${_quote.text}' updated"))
      .catchError(handleError);

  String shorten(String txt) =>
      txt.length > 20 ? txt.substring(0, 20).trim() + "..." : txt;

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_book.authorId), _author.name),
        Breadcrumb.link(showAuthorUrl(_book.authorId), "books"),
        Breadcrumb.link(showBookUrl(_book.authorId, _book.id), _book.title),
        Breadcrumb.link(showBookUrl(_book.authorId, _book.id), "quotes"),
        Breadcrumb.link(showQuoteUrl(_book.authorId, _book.id, _quote.id),
                shorten(_oldText))
            .last(),
      ];
}
