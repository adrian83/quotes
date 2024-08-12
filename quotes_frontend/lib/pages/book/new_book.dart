import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/book/service.dart';
import 'package:quotes_frontend/pages/common/new.dart';
import 'package:quotes_frontend/widgets/common/entity_form.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/book.dart';

class NewBookPage extends NewPage<Book, NewBookEntityForm> {
  final String _authorId;
  final BookService _bookService;

  const NewBookPage(super.key, super.title, this._authorId, this._bookService);

  String get authorId => _authorId;
  BookService get bookService => _bookService;

  @override
  NewBookEntityForm createEntityForm(BuildContext context, Book? entity) => NewBookEntityForm(_authorId, entity);

  @override
  Future<Book> persist(Book entity) => entity.id == emptyId ? _bookService.create(entity) : _bookService.update(entity);

  @override
  String successMessage() => "Book created / updated";

  @override
  Future<Book?> init() => Future.value(null);
}

class NewBookEntityForm extends EntityForm<Book> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final String _authorId;
  final Book? _book;

  NewBookEntityForm(this._authorId, this._book) {
    if (_book != null) {
      _titleController.text = _book!.title;
      _descController.text = _book!.description ?? "";
    }
  }

  @override
  Book createEntity() => Book(_book?.id ?? emptyId, _titleController.text, _descController.text, _authorId, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: _titleController),
          TextFormField(controller: _descController, maxLines: 10),
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
    _titleController.dispose();
    _descController.dispose();
  }
}
