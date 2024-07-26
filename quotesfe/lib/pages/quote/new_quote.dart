import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/common/new.dart';
import 'package:quotesfe/widgets/common/entity_form.dart';

class NewQuotePage extends NewPage<Quote, NewQuoteEntityForm> {
  final String _authorId, _bookId;
  final QuoteService _quoteService;

  const NewQuotePage(Key? key, String title, this._authorId, this._bookId, this._quoteService) : super(key, title);

  String get bookId => _bookId;
  String get authorId => _authorId;
  QuoteService get quoteService => _quoteService;

  @override
  NewQuoteEntityForm createEntityForm(BuildContext context, Quote? entity) => NewQuoteEntityForm(_authorId, _bookId, entity);

  @override
  Future<Quote> persist(Quote entity) => entity.id == null ? _quoteService.create(entity) : _quoteService.update(entity);

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
  Quote createEntity() => Quote(_quote?.id, _textController.text, _authorId, _bookId, DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: _textController, maxLines: 15),
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
