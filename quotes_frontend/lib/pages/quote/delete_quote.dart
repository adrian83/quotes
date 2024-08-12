import 'package:quotes_frontend/domain/quote/service.dart';
import 'package:quotes_frontend/pages/common/delete.dart';

class DeleteQuotePage extends DeletePage {
  final String _authorId, _bookId, _quoteId;
  final QuoteService _quoteService;

  const DeleteQuotePage(super.key, super.title, this._authorId, this._bookId, this._quoteId, this._quoteService);

  @override
  Future<void> deleteEntity() => _quoteService.delete(_authorId, _bookId, _quoteId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Quote removed";
}
