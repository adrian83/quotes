import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/common/update.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class UpdateAuthorPage extends UpdatePage<Author, UpdateAuthorEntityForm> {
  static String routePattern =
      r'^/authors/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId;
  final AuthorService _authorService;

  const UpdateAuthorPage(
      Key? key, String title, this.authorId, this._authorService)
      : super(key, title);

  @override
  UpdateAuthorEntityForm createEntityForm(
          BuildContext context, Author? entity) =>
      UpdateAuthorEntityForm(authorId, entity);

  @override
  Future<Author> persist(Author entity) => _authorService.update(entity);

  @override
  String successMessage() => "Author updated";

  @override
  Future<Author?> init() => _authorService.find(authorId);
}

class UpdateAuthorEntityForm extends EntityForm<Author> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  final String authorId;

  UpdateAuthorEntityForm(this.authorId, Author? author) {
    if (author != null) {
      nameController.text = author.name;
      descController.text = author.description ?? "";
    }
  }

  @override
  Author createEntity() => Author(authorId, nameController.text,
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
