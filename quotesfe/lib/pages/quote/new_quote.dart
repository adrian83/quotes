import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/common/new.dart';
import 'package:quotesfe/pages/widgets/common/entity_form.dart';

class NewQuotePage extends NewPage<Quote, NewQuoteEntityForm> {
  final String authorId, bookId;
  final QuoteService quoteService;

  const NewQuotePage(
      Key? key, String title, this.authorId, this.bookId, this.quoteService)
      : super(key, title);

  @override
  NewQuoteEntityForm createEntityForm(BuildContext context, Quote? entity) =>
      NewQuoteEntityForm(authorId, bookId, entity);

  @override
  Future<Quote> persist(Quote entity) => quoteService.create(entity);

  @override
  String successMessage() => "Quote created";

  @override
  Future<Quote?> init() => Future.value(null);
}

class NewQuoteEntityForm extends EntityForm<Quote> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final String _authorId, _bookId;
  final Quote? _quote;

  NewQuoteEntityForm(this._authorId, this._bookId, this._quote) {
    if (_quote != null) {
      _textController.text = _quote!.text;
    }
  }

  @override
  Quote createEntity() => Quote(null, _textController.text, _authorId, _bookId,
      DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: _textController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: action,
              child: const Text('Submit'),
            ),
          ),
        ],
      ));

  @override
  void dispose() {
    _textController.dispose();
  }
}
