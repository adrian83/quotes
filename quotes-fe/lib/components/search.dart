import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../domain/common/router.dart';
import 'common/error_handler.dart';
import 'author/author_search.dart';
import 'book/book_search.dart';
import 'quote/quote_search.dart';

@Component(
  selector: 'search',
  templateUrl: 'search.template.html',
  providers: [ClassProvider(QuotesRouter)],
  directives: const [
    coreDirectives,
    formDirectives,
    AuthorSearchComponent,
    BookSearchComponent,
    QuoteSearchComponent
  ],
)
class SearchComponent extends ErrorHandler {
  final QuotesRouter _router;

  String _phrase = "";
  String _curentPhrase = "";

  SearchComponent(this._router) {}

  String get phrase => _phrase;
  String get curentPhrase => _curentPhrase;

  void set curentPhrase(String p) {
    _curentPhrase = p;
  }

  void set phrase(String p) {
    _phrase = p;
  }

  void executeSearch() {
    _phrase = _curentPhrase;
  }

  void createAuthor() => _router.createAuthor();
}
