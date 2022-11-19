import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/common/new.dart';
import 'package:quotesfe/pages/widgets/common/entity_form.dart';

class NewBookPage extends NewPage<Book, NewBookEntityForm> {
  final String authorId;
  final BookService bookService;

  const NewBookPage(Key? key, String title, this.authorId, this.bookService)
      : super(key, title);

  @override
  NewBookEntityForm createEntityForm(BuildContext context, Book? entity) =>
      NewBookEntityForm(authorId, entity);

  @override
  Future<Book> persist(Book entity) => entity.id == null
      ? bookService.create(entity)
      : bookService.update(entity);

  @override
  String successMessage() => "Book created / updated";

  @override
  Future<Book?> init() => Future.value(null);
}

class NewBookEntityForm extends EntityForm<Book> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final String _authorId;
  final Book? _book;

  NewBookEntityForm(this._authorId, this._book) {
    if (_book != null) {
      titleController.text = _book!.title;
      descController.text = _book!.description ?? "";
    }
  }

  @override
  Book createEntity() => Book(null, titleController.text, descController.text,
      _authorId, DateTime.now(), DateTime.now());

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
