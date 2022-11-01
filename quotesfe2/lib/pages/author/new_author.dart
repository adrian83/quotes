import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/common/new.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class NewAuthorPage extends NewPage<Author, NewAuthorEntityForm> {
  static String routePattern = r'^/authors/new/?(&[\w-=]+)?$';

  final AuthorService _authorService;

  const NewAuthorPage(Key? key, String title, this._authorService)
      : super(key, title);

  @override
  NewAuthorEntityForm createEntityForm(BuildContext context, Author? _) =>
      NewAuthorEntityForm();

  @override
  Future<Author> persist(Author entity) => _authorService.create(entity);

  @override
  String successMessage() => "Author created";

  @override
  Future<Author?> init() => Future.value(null);
}

class NewAuthorEntityForm extends EntityForm<Author> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  @override
  Author createEntity() => Author(null, nameController.text,
      descController.text, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: nameController),
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
    nameController.dispose();
    descController.dispose();
  }
}
