import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/common.dart';
import 'package:quotesfe2/pages/widgets/author.dart';

class NewAuthorPage extends StatefulWidget {
  static String routePattern = r'^/authors/new/?(&[\w-=]+)?$';

  final String title;
  final AuthorService _authorService;

  const NewAuthorPage(Key? key, this.title, this._authorService) : super(key: key);

  @override
  State<NewAuthorPage> createState() => _NewAuthorPageState();
}

class _NewAuthorPageState extends State<NewAuthorPage> {

final _formKey = GlobalKey<FormState>();
final nameController = TextEditingController();
final descController = TextEditingController();

  void _persist() {
    setState(() {
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

AuthorEntry authorToWidget(Author a) => AuthorEntry(null, a);

class ShowAuthorPage extends ShowEntityPage<Author> {
  static String routePattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final AuthorService _authorService;
  final String entityId;

  const ShowAuthorPage(Key? key, String title, this.entityId, this._authorService) : super(key, title, authorToWidget);

  @override
  Future<Author> findEntity() => _authorService.find(entityId);
}
