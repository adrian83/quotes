import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/author/service.dart';
import 'package:quotes_frontend/pages/common/new.dart';
import 'package:quotes_frontend/widgets/common/entity_form.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/author.dart';

class NewAuthorPage extends NewPage<Author, NewAuthorEntityForm> {
  final AuthorService _authorService;

  const NewAuthorPage(super.key, super.title, this._authorService);

  AuthorService get authorService => _authorService;

  @override
  NewAuthorEntityForm createEntityForm(BuildContext context, Author? entity) => NewAuthorEntityForm(entity);

  @override
  Future<Author> persist(Author entity) => entity.id == emptyId ? authorService.create(entity) : authorService.update(entity);

  @override
  String successMessage() => "Author created / updated";

  @override
  Future<Author?> init() => Future.value(null);
}

class NewAuthorEntityForm extends EntityForm<Author> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final Author? _author;

  NewAuthorEntityForm(this._author) {
    if (_author != null) {
      _nameController.text = _author!.name;
      _descController.text = _author!.description ?? "";
    }
  }

  @override
  Author createEntity() => Author(_author?.id ?? emptyId, _nameController.text, _descController.text, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: _nameController),
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
    _nameController.dispose();
    _descController.dispose();
  }
}
