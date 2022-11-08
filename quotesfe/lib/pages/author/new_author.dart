import 'package:flutter/material.dart';
import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/pages/common/new.dart';
import 'package:quotesfe/pages/widgets/common/entity_form.dart';

class NewAuthorPage extends NewPage<Author, NewAuthorEntityForm> {
  static String routePattern = r'^/authors/new/?(&[\w-=]+)?$';

  final AuthorService authorService;

  const NewAuthorPage(Key? key, String title, this.authorService)
      : super(key, title);

  @override
  NewAuthorEntityForm createEntityForm(BuildContext context, Author? entity) =>
      NewAuthorEntityForm(entity);

  @override
  Future<Author> persist(Author entity) => entity.id == null
      ? authorService.create(entity)
      : authorService.update(entity);

  @override
  String successMessage() => "Author created / updated";

  @override
  Future<Author?> init() => Future.value(null);
}

class NewAuthorEntityForm extends EntityForm<Author> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  Author? author;

  NewAuthorEntityForm(this.author) {
    if (author != null) {
      nameController.text = author!.name;
      descController.text = author!.description ?? "";
    }
  }

  @override
  Author createEntity() => Author(author?.id, nameController.text,
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
