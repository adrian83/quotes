import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/quote/service.dart';
import 'package:quotes_frontend/pages/quote/new_quote.dart';
import 'package:quotes_common/domain/quote.dart';

class UpdateQuotePage extends NewQuotePage {
  final String _quoteId;

  const UpdateQuotePage(Key? key, String title, String authorId, String bookId, this._quoteId, QuoteService quoteService) : super(key, title, authorId, bookId, quoteService);

  @override
  NewQuoteEntityForm createEntityForm(BuildContext context, Quote? entity) => NewQuoteEntityForm(authorId, bookId, entity);

  @override
  Future<Quote?> init() => quoteService.find(authorId, bookId, _quoteId);

  @override
  String successMessage() => "Quote updated";
}
