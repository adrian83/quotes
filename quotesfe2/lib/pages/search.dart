import 'package:flutter/material.dart';

import 'package:quotesfe2/pages/widgets/author.dart';
import 'package:quotesfe2/pages/widgets/book.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/common/page.dart';


class SearchPage extends StatefulWidget {

  static String routePattern = r'^/search/?(&[\w-=]+)?$';

  final String title;
  final AuthorService _authorService;
  final BookService _bookService;

  const SearchPage(Key? key, this.title, this._authorService, this._bookService) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState(_authorService, _bookService);
}

class _SearchPageState extends State<SearchPage> {

final AuthorService _authorService;
final BookService _bookService;

  List<Author> _authors = [];
  List<Book> _books = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController myController = TextEditingController();

  _SearchPageState(this._authorService, this._bookService);

  void _search(String? text) {
    setState(() {
      _authorService.listAuthors(text ?? "", PageRequest(3, 0)).then((resp) => _authors = resp.elements);
      _bookService.listBooks(text ?? "", PageRequest(3, 0)).then((resp) => _books = resp.elements);
    });
  }

  @override
  Widget build(BuildContext context) {

    var authorsWidgets = _authors.map((e) => AuthorEntry(null, e));
    var booksWidgets = _books.map((e) => BookEntry(null, e));


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
                onPressed: () => _search(textField.controller?.value.text)
              ),
            ),
            const Text('Authors'),
            ...authorsWidgets,
            const Text('Books'),
            ...booksWidgets
          ],
        ),
      ),
    );
  }
}
