import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/domain/common/errors.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/pages/common.dart';
import 'package:quotesfe2/pages/widgets/book.dart';

class NewBookPage extends StatefulWidget {
  static String routePattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/new/?(&[\w-=]+)?$';

  final String title;

  final BookService _bookService;
  final String authorId;


  NewBookPage(Key? key, this.title, this.authorId, this._bookService) : super(key: key);

  @override
  State<NewBookPage> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> {

final _formKey = GlobalKey<FormState>();
final titleController = TextEditingController();
final descController = TextEditingController();

  void _persist() {
    setState(() {
      print("save book");
      var book = Book(null, titleController.text, descController.text, widget.authorId, DateTime.now(), DateTime.now());
      widget._bookService.create(book);

    });
  }

  @override
  Widget build(BuildContext context) {

    var form =  Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(controller: titleController),
          TextFormField(controller: descController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _persist,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            form
          ],
        ),
      )
    );
  }

    @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}

BookEntry bookToWidget(Book b) => BookEntry(null, b);

class ShowBookPage extends ShowEntityPage<Book> {
  static String routePattern = r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final BookService _bookService;
  final String bookId;
  final String authorId;

  const ShowBookPage(Key? key, String title, this.authorId, this.bookId, this._bookService) : super(key, title, bookToWidget);

  @override
  Future<Book> findEntity() => _bookService.find(authorId, bookId);
}
