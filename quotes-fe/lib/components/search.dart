import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'author/author_search.dart';
import 'book/book_search.dart';
import 'quote/quote_search.dart';
import '../domain/common/router.dart';
import 'common/error_handler.dart';

@Component(
  selector: 'search',
  templateUrl: 'search.template.html',
  providers: [ClassProvider(QuotesRouter)],
  directives: [coreDirectives, formDirectives, AuthorSearchComponent, BookSearchComponent, QuoteSearchComponent],
)
class SearchComponent extends ErrorHandler {
  final QuotesRouter _router;

  String phrase = "";
  String curentPhrase = "";

  SearchComponent(this._router) {}

  void executeSearch() {
    phrase = curentPhrase;
  }

  void createAuthor() => _router.createAuthor();
}
