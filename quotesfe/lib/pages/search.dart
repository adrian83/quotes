import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/widgets/quote/list_entry.dart';
import 'package:quotesfe/widgets/quote/page_entry.dart';
import 'package:quotesfe/widgets/author/list_entry.dart';
import 'package:quotesfe/widgets/author/page_entry.dart';
import 'package:quotesfe/widgets/book/list_entry.dart';
import 'package:quotesfe/widgets/book/page_entry.dart';
import 'package:quotesfe/pages/common/page.dart';
import 'package:quotesfe/paths.dart';

class SearchPage extends AbsPage {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final String searchPhrase;

  const SearchPage(Key key, String title, this._authorService,
      this._bookService, this._quoteService, this.searchPhrase)
      : super(key, title);

  @override
  State<SearchPage> createState() => _SearchPageState<SearchPage>();
}

class _SearchPageState<T extends SearchPage> extends PageState<SearchPage> {
  final TextEditingController _searchPhraseController = TextEditingController();

  late TextFormField _searchPhraseField;
  late AuthorPageEntry _authorsWidget;
  late BookPageEntry _booksWidgets;
  late QuotePageEntry _quotesWidgets;

  _SearchPageState() {
    _searchPhraseField = TextFormField(controller: _searchPhraseController);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchPhraseController.text = widget.searchPhrase;
      newWidgets();
    });
  }

  newWidgets() {
    newAuthorWidget();
    newBookWidget();
    newQuotesWidget();
  }

  void refresh() {
    setState(() {
      newWidgets();
    });
  }

  void newAuthorWidget() {
    _authorsWidget = AuthorPageEntry(
        UniqueKey(), changeAuthorsPage, _toAuthorEntry, errorHandler());
  }

  void newBookWidget() {
    _booksWidgets = BookPageEntry(
        UniqueKey(), changeBooksPage, _toBookEntry, errorHandler());
  }

  void newQuotesWidget() {
    _quotesWidgets = QuotePageEntry(
        UniqueKey(), changeQuotesPage, _toQuoteEntry, errorHandler());
  }

  AuthorEntry _toAuthorEntry(Author a) =>
      AuthorEntry(null, a, refresh, false, false, true, false);

  BookEntry _toBookEntry(Book b) =>
      BookEntry(null, b, refresh, false, false, true, true);

  QuoteEntry _toQuoteEntry(Quote q) =>
      QuoteEntry(null, q, refresh, false, false, true, true);

  Future<AuthorsPage> changeAuthorsPage(PageRequest pageReq) =>
      widget._authorService.listAuthors(searchPhrase(), pageReq);

  Future<BooksPage> changeBooksPage(PageRequest pageReq) =>
      widget._bookService.listBooks(searchPhrase(), pageReq);

  Future<QuotesPage> changeQuotesPage(PageRequest pageReq) =>
      widget._quoteService.listQuotes(searchPhrase(), pageReq);

  String searchPhrase() => _searchPhraseController.value.text;

  Future _gotoSearchPageWithNewSearchPhrase() =>
      Navigator.pushNamed(context, searchPath(searchPhrase()));

  Future _gotoNewAuthorPage() =>
      Navigator.pushNamed(context, createAuthorPath())
          .then((value) => refresh());

  @override
  List<Widget> renderWidgets(BuildContext context) {
    return [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _searchPhraseField,
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    child: const Text('Search'),
                    onPressed: _gotoSearchPageWithNewSearchPhrase)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                    child: const Text('Create new author'),
                    onPressed: _gotoNewAuthorPage)),
            const SizedBox(height: 20),
            _authorsWidget,
            const SizedBox(height: 20),
            _booksWidgets,
            const SizedBox(height: 20),
            _quotesWidgets,
            const SizedBox(height: 30)
          ],
        ),
      )
    ];
  }
}
