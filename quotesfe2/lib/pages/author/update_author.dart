import 'package:flutter/material.dart';
import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/service.dart';
import 'package:quotesfe2/pages/author/new_author.dart';

class UpdateAuthorPage extends NewAuthorPage {
  static String routePattern =
      r'^/authors/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId;

  const UpdateAuthorPage(
      Key? key, String title, this.authorId, AuthorService authorService)
      : super(key, title, authorService);

  @override
  String successMessage() => "Author updated";

  @override
  Future<Author?> init() => authorService.find(authorId);
}
