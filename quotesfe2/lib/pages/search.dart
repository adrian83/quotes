import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';

import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/domain/common/page.dart';


class SearchPage extends StatefulWidget {

  static String routePattern = r'^/search/?(&[\w-=]+)?$';

  final String title;
  final AuthorService _authorService;

  const SearchPage(Key? key, this.title, this._authorService) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState(_authorService);
}

class _SearchPageState extends State<SearchPage> {

final AuthorService _authorService;
  final _formKey = GlobalKey<FormState>();

  List<Author> authors = [];


_SearchPageState(this._authorService);




  void _search() {
    setState(() {
      _authorService.listAuthors("", PageRequest(3, 0)).then((resp) => authors = resp.elements);
    });
  }

@override
  Widget build(BuildContext context) {

    var aw = authors.map((e) => Text('author: ${e.name}'));


return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _search();
              },
              child: const Text('Submit'),
            ),
          ),
          ...aw
        ],
        ),
      ),
    );
  }
}




