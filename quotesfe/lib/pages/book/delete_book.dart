import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/common/delete.dart';

class DeleteBookPage extends DeletePage {
  final String _authorId, _bookId;
  final BookService _bookService;

  const DeleteBookPage(super.key, super.title, this._authorId, this._bookId, this._bookService);

  @override
  Future<void> deleteEntity() => _bookService.delete(_authorId, _bookId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Book removed";
}
