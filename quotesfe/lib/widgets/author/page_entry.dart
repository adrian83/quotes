import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/widgets/author/list_entry.dart';
import 'package:quotesfe/widgets/page_entry.dart';

class AuthorPageEntry extends PageEntry<Author, AuthorsPage, AuthorEntry> {
  const AuthorPageEntry(
      Key? key,
      PageChangeAction<Author> pageChangeAction,
      ToEntryTransformer<Author, AuthorEntry> toEntryTransformer,
      ErrorHandler errorHandler)
      : super(
            key, "Authors", pageChangeAction, toEntryTransformer, errorHandler);
}
