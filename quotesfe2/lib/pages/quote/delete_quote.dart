import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/common/delete.dart';

class DeleteQuotePage extends DeletePage {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId, bookId, quoteId;
  final QuoteService _quoteService;

  const DeleteQuotePage(Key? key, String title, this.authorId, this.bookId,
      this.quoteId, this._quoteService)
      : super(key, title);

  @override
  Future<void> deleteEntity() =>
      _quoteService.delete(authorId, bookId, quoteId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Quote removed";
}
