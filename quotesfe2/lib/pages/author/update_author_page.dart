import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/service.dart';

import '../widgets/info/error_box.dart';

class UpdateAuthorPage extends StatefulWidget {
  static String routePattern =
      r'^/authors/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String title;
  final String entityId;
  final AuthorService _authorService;

  const UpdateAuthorPage(
      Key? key, this.title, this.entityId, this._authorService)
      : super(key: key);

  @override
  State<UpdateAuthorPage> createState() => _UpdateAuthorPageState();
}

class _UpdateAuthorPageState extends State<UpdateAuthorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  dynamic error;

  void _update() {
    var author = Author(widget.entityId, nameController.text,
        descController.text, DateTime.now(), DateTime.now());
    widget._authorService.update(author).then((updatedAuthor) {
      setState(() {
        nameController.text = updatedAuthor.name;
        descController.text = updatedAuthor.description ?? "";
      });
    }).catchError((e) {
      setState(() {
        error = e;
      });
    });
  }

  @override
  initState() {
    super.initState();
    widget._authorService.find(widget.entityId).then((a) {
      setState(() {
        nameController.text = a.name;
        descController.text = a.description ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: nameController),
          TextFormField(
            controller: descController,
            maxLines: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _update,
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );

    var children = <Widget>[];
    if (error != null) {
      children.add(Errors(null, error!));
    }
    children.add(form);

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

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
}
