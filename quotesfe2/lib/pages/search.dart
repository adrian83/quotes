import 'package:flutter/material.dart';

import 'package:quotesfe2/pages/widgets/author.dart';
import 'package:quotesfe2/pages/widgets/book.dart';
import 'package:quotesfe2/pages/widgets/quote.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/domain/common/page.dart';

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
    print("new search");
    setState(() {
      print("_search");
      newWidgets();
    });
  }

  newWidgets() {
      authorsWidget = AuthorPageEntry(
        UniqueKey(), changeAuthorsPage, (Author a){ 
          print("new AuthorEntry $a");
          return AuthorEntry(null, a);
        });
      booksWidgets = BookPageEntry(
        UniqueKey(), changeBooksPage, (Book b) => BookEntry(null, b));
      quotesWidgets = QuotePageEntry(
        UniqueKey(), changeQuotesPage, (Quote q) => QuoteEntry(null, q));
  }

  Future<AuthorsPage> changeAuthorsPage(PageRequest pageReq) {
    var searchPhrase = myController.value.text;
    print("changeAuthorsPage $searchPhrase");
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

    print("build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textField,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () => _search(textField.controller?.value.text)),
            ),
            authorsWidget,
            booksWidgets,
            quotesWidgets,
          ],
        ),
      ),
    );
  }
}
