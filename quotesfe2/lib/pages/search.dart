import 'package:flutter/material.dart';

import 'package:quotesfe2/pages/widgets/author.dart';
import 'package:quotesfe2/pages/widgets/book.dart';
import 'package:quotesfe2/pages/widgets/paging.dart';
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

  const SearchPage(Key? key, this.title, this._authorService, this._bookService,
      this._quoteService)
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthorsPage _authors = AuthorsPage.empty();
  List<Book> _books = [];
  List<Quote> _quotes = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController myController = TextEditingController();

  _SearchPageState();

  void _search(String? text) {
    setState(() {
      var searchPhrase = text ?? "";

      widget._authorService
          .listAuthors(searchPhrase, PageRequest(3, 0))
          .then((resp) => _authors = resp);

      widget._bookService
          .listBooks(searchPhrase, PageRequest(3, 0))
          .then((resp) => _books = resp.elements);

      widget._quoteService
          .listQuotes(searchPhrase, PageRequest(3, 0))
          .then((resp) => _quotes = resp.elements);
    });
  }

  Future<AuthorsPage> changeAuthorsPage(PageRequest pageReq) {
    var searchPhrase = myController.value.text;
          return widget._authorService
          .listAuthors(searchPhrase, pageReq);
  }



  @override
  Widget build(BuildContext context) {
    var authorsWidget = AuthorPageEntry(null, changeAuthorsPage);
    var booksWidgets = _books.map((e) => BookEntry(null, e));
    var quotesWidgets = _quotes.map((e) => QuoteEntry(null, e));

    var textField = TextFormField(controller: myController);

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
            _searchEntityHeader('Books'),
            ...booksWidgets,
            _searchEntityHeader('Quotes'),
            ...quotesWidgets
          ],
        ),
      ),
    );
  }

  Text _searchEntityHeader(String text) {
    return Text(text, style: Theme.of(context).textTheme.headline4);
  }

}
