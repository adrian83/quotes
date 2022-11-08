import 'package:flutter/material.dart';
import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/quote/new_quote.dart';

class UpdateQuotePage extends NewQuotePage {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String _quoteId;

  const UpdateQuotePage(Key? key, String title, String authorId, String bookId,
      this._quoteId, QuoteService quoteService)
      : super(key, title, authorId, bookId, quoteService);

  @override
  NewQuoteEntityForm createEntityForm(BuildContext context, Quote? entity) =>
      NewQuoteEntityForm(authorId, bookId, entity);

  @override
  Future<Quote?> init() => quoteService.find(authorId, bookId, _quoteId);

  @override
  String successMessage() => "Quote updated";
}
