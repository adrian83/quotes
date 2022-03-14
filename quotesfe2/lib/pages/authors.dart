import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';

import 'package:quotesfe2/domain/author/service.dart';

class NewAuthorPage extends StatefulWidget {
  static String routePattern = r'^/authors/new/?(&[\w-=]+)?$';

  final String title;

  final AuthorService _authorService;


  NewAuthorPage(Key? key, this.title, this._authorService) : super(key: key);

  @override
  State<NewAuthorPage> createState() => _NewAuthorPageState();
}

class _NewAuthorPageState extends State<NewAuthorPage> {

final _formKey = GlobalKey<FormState>();
final nameController = TextEditingController();
final descController = TextEditingController();

  void _persist() {
    setState(() {
      print("save author");
      var author = Author(null, nameController.text, descController.text, DateTime.now(), DateTime.now());
      widget._authorService.create(author);

    });
  }

  @override
  Widget build(BuildContext context) {

    var form =  Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(controller: nameController),
          TextFormField(controller: descController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _persist,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            form
          ],
        ),
      )
    );
  }

    @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
}

class ShowAuthorPage extends StatefulWidget {
  static String routePattern = r'^/authors/show/([0-9]+)/?(&[\w-=]+)?$';

  final String _title;
  final String _id;

  const ShowAuthorPage(Key? key, this._title, this._id) : super(key: key);

  @override
  State<ShowAuthorPage> createState() => _ShowAuthorPageState();
}

class _ShowAuthorPageState extends State<ShowAuthorPage> {
  void _persist() {
    setState(() {
      print("update");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('???'),
            Text('test', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _persist,
        tooltip: 'Save',
        child: const Icon(Icons.add),
      ),
    );
  }
}
