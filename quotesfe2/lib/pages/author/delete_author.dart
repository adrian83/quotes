import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/common/delete.dart';

class DeleteAuthorPage extends DeletePage {
  static String routePattern =
      r'^/authors/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId;
  final AuthorService _authorService;

  const DeleteAuthorPage(
      Key? key, String title, this.authorId, this._authorService)
      : super(key, title);

  @override
  Future<void> deleteEntity() => _authorService.delete(authorId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Author removed";
}
