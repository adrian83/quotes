import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:quotesfe/pages/widgets/author/list_entry.dart';
import 'package:quotesfe/pages/widgets/author/page_entry.dart';

import 'package:quotesfe/pages/widgets/book/list_entry.dart';
import 'package:quotesfe/pages/widgets/book/page_entry.dart';
import 'package:quotesfe/pages/widgets/quote.dart';
import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/pages/widgets/quote/list_entry.dart';

class SearchPage extends StatefulWidget {
  static String routePattern = r'^/search/?(&[\w-=]+)?$';

  final String title;
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;

  const SearchPage(Key key, this.title, this._authorService, this._bookService,
      this._quoteService)
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController myController = TextEditingController();

  late TextFormField textField;
  late AuthorPageEntry authorsWidget;
  late BookPageEntry booksWidgets;
  late QuotePageEntry quotesWidgets;

  _SearchPageState() {
    textField = TextFormField(controller: myController);
    newWidgets();
  }

  void _search(String? text) {
    developer.log("new search with text: '$text'");
    setState(() {
      newWidgets();
    });
  }

  newWidgets() {
    newAuthorWidget();
    newBookWidget();
    newQuotesWidget();
  }

  void newAuthorWidget() {
    authorsWidget = AuthorPageEntry(UniqueKey(), changeAuthorsPage,
        (Author a) => AuthorEntry(null, a, false, true, false));
  }

  void newBookWidget() {
    booksWidgets = BookPageEntry(
        UniqueKey(),
        changeBooksPage,
        (Book b) => BookEntry(
              null,
              b,
              false,
              true,
              true,
            ));
  }

  void newQuotesWidget() {
    quotesWidgets = QuotePageEntry(UniqueKey(), changeQuotesPage,
        (Quote q) => QuoteEntry(null, q, false, true, true));
  }

  Future<AuthorsPage> changeAuthorsPage(PageRequest pageReq) {
    var searchPhrase = myController.value.text;
    return widget._authorService.listAuthors(searchPhrase, pageReq);
  }

  Future<BooksPage> changeBooksPage(PageRequest pageReq) {
    var searchPhrase = myController.value.text;
    return widget._bookService.listBooks(searchPhrase, pageReq);
  }

  Future<QuotesPage> changeQuotesPage(PageRequest pageReq) {
    var searchPhrase = myController.value.text;
    return widget._quoteService.listQuotes(searchPhrase, pageReq);
  }

  @override
  Widget build(BuildContext context) {
    developer.log("building search page");

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                textField,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                      child: const Text('Search'),
                      onPressed: () =>
                          _search(textField.controller?.value.text)),
                ),
                const SizedBox(height: 20),
                authorsWidget,
                const SizedBox(height: 20),
                booksWidgets,
                const SizedBox(height: 20),
                quotesWidgets,
                const SizedBox(height: 30)
              ],
            ),
          ),
        ));
  }
}