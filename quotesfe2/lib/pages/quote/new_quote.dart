import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/domain/quote/service.dart';
import 'package:quotesfe2/pages/common/new.dart';
import 'package:quotesfe2/pages/widgets/common/entity_form.dart';

class NewQuotePage extends NewPage<Quote, NewQuoteEntityForm> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/new/?(&[\w-=]+)?$';

  final QuoteService _quoteService;
  final String authorId, bookId;

  const NewQuotePage(
      Key? key, String title, this.authorId, this.bookId, this._quoteService)
      : super(key, title);

  @override
  NewQuoteEntityForm createEntityForm(BuildContext context, Quote? _) =>
      NewQuoteEntityForm(authorId, bookId);

  @override
  Future<Quote> persist(Quote entity) => _quoteService.create(entity);

  @override
  String successMessage() => "Quote created";

  @override
  Future<Quote?> init() => Future.value(null);
}

class NewQuoteEntityForm extends EntityForm<Quote> {
  final String authorId, bookId;

  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  NewQuoteEntityForm(this.authorId, this.bookId);

  @override
  Quote createEntity() => Quote(null, textController.text, authorId, bookId,
      DateTime.now(), DateTime.now());

  @override
  Form createForm(BuildContext context, Function()? action) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: textController),
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
    textController.dispose();
  }
}
