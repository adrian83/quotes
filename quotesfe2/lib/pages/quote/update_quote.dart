import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/common/update.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class UpdateQuotePage extends UpdatePage<Quote, UpdateQuoteEntityForm> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/quotes/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String _authorId, _bookId, _quoteId;
  final QuoteService _quoteService;

  const UpdateQuotePage(Key? key, String title, this._authorId, this._bookId,
      this._quoteId, this._quoteService)
      : super(key, title);

  @override
  UpdateQuoteEntityForm createEntityForm(BuildContext context, Quote? entity) =>
      UpdateQuoteEntityForm(_authorId, _bookId, _quoteId, entity);

  @override
  Future<Quote?> init() => _quoteService.find(_authorId, _bookId, _quoteId);

  @override
  Future<Quote> persist(Quote entity) => _quoteService.update(entity);

  @override
  String successMessage() => "Quote updated";
}

class UpdateQuoteEntityForm extends EntityForm<Quote> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  final String authorId, bookId, quoteId;

  UpdateQuoteEntityForm(
      this.authorId, this.bookId, this.quoteId, Quote? quote) {
    if (quote != null) {
      textController.text = quote.text;
    }
  }

  @override
  Quote createEntity() => Quote(quoteId, textController.text, authorId, bookId,
      DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: textController,
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
    textController.dispose();
  }
}
