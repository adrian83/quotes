import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/pages/widgets/author/list_entry.dart';
import 'package:quotesfe/pages/widgets/common.dart';

class AuthorPageEntry extends PageEntry<Author, AuthorsPage, AuthorEntry> {
  const AuthorPageEntry(
      Key? key,
      PageChangeAction<Author> pageChangeAction,
      ToEntryTransformer<Author, AuthorEntry> toEntryTransformer,
      ErrorHandler errorHandler)
      : super(
            key, "Authors", pageChangeAction, toEntryTransformer, errorHandler);
}
