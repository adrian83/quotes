import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/pages/author/new_author.dart';
import 'package:quotes_common/domain/author.dart';

class UpdateAuthorPage extends NewAuthorPage {
  final String _authorId;

  const UpdateAuthorPage(Key? key, String title, this._authorId, AuthorService authorService) : super(key, title, authorService);

  @override
  String successMessage() => "Author updated";

  @override
  Future<Author?> init() => authorService.find(_authorId);
}
