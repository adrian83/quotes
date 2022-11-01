import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/pages/common/new.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class NewBookPage extends NewPage<Book, NewBookEntityForm> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/new/?(&[\w-=]+)?$';

  final BookService _bookService;
  final String authorId;

  const NewBookPage(Key? key, String title, this.authorId, this._bookService)
      : super(key, title);

  @override
  NewBookEntityForm createEntityForm(BuildContext context, Book? _) =>
      NewBookEntityForm(authorId);

  @override
  Future<Book> persist(Book entity) => _bookService.create(entity);

  @override
  String successMessage() => "Book created";

  @override
  Future<Book?> init() => Future.value(null);
}

class NewBookEntityForm extends EntityForm<Book> {
  final String authorId;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  NewBookEntityForm(this.authorId);

  @override
  Book createEntity() => Book(null, titleController.text, descController.text,
      authorId, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: titleController),
          TextFormField(controller: descController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: action,
              child: const Text('Submit'),
            ),
          ),
        ],
      ));

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
  }
}
