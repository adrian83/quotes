import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/pages/common/update.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class UpdateBookPage extends UpdatePage<Book, UpdateBookEntityForm> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId, bookId;
  final BookService _bookService;

  const UpdateBookPage(
      Key? key, String title, this.authorId, this.bookId, this._bookService)
      : super(key, title);

  @override
  UpdateBookEntityForm createEntityForm(BuildContext context, Book? entity) =>
      UpdateBookEntityForm(authorId, bookId, entity);

  @override
  Future<Book> persist(Book entity) => _bookService.update(entity);

  @override
  String successMessage() => "Book updated";

  @override
  Future<Book?> init() => _bookService.find(authorId, bookId);
}

class UpdateBookEntityForm extends EntityForm<Book> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final String authorId, bookId;

  UpdateBookEntityForm(this.authorId, this.bookId, Book? book) {
    if (book != null) {
      titleController.text = book.title;
      descController.text = book.description ?? "";
    }
  }

  @override
  Book createEntity() => Book(authorId, titleController.text,
      descController.text, authorId, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(controller: titleController),
            TextFormField(
              controller: descController,
              maxLines: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: action,
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
  }
}
