import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/pages/common/delete.dart';

class DeleteAuthorPage extends DeletePage {
  final String _authorId;
  final AuthorService _authorService;

  const DeleteAuthorPage(super.key, super.title, this._authorId, this._authorService);

  @override
  Future<void> deleteEntity() => _authorService.delete(_authorId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Author removed";
}
