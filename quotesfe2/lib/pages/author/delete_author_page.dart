import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/widgets/info/info_box.dart';

import '../widgets/info/error_box.dart';

class DeleteAuthorPage extends StatefulWidget {
  static String routePattern =
      r'^/authors/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String title;
  final String entityId;
  final AuthorService _authorService;

  const DeleteAuthorPage(
      Key? key, this.title, this.entityId, this._authorService)
      : super(key: key);

  @override
  State<DeleteAuthorPage> createState() => _DeleteAuthorPageState();
}

class _DeleteAuthorPageState extends State<DeleteAuthorPage> {
  dynamic error;
  String? message;
  final String question = "Are you sure?";

  void _delete() {
    widget._authorService.delete(widget.entityId).then((updatedAuthor) {
      setState(() {
        message = "Author removed";
      });
    }).catchError((e) {
      setState(() {
        error = e;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (error != null) {
      children.add(Errors(null, error!));
    }

    if (message != null) {
      children.add(Info(null, message!));
    } else {
      children.add(Text(question));
      children.add(ElevatedButton(
        onPressed: _delete,
        child: const Text('Delete'),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ));
  }
}
