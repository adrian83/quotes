import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/common/delete.dart';

class DeleteQuotePage extends DeletePage {
  final String _authorId, _bookId, _quoteId;
  final QuoteService _quoteService;

  const DeleteQuotePage(Key? key, String title, this._authorId, this._bookId,
      this._quoteId, this._quoteService)
      : super(key, title);

  @override
  Future<void> deleteEntity() =>
      _quoteService.delete(_authorId, _bookId, _quoteId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Quote removed";
}
