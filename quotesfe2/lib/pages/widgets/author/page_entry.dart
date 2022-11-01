import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/pages/widgets/author/list_entry.dart';
import 'package:quotesfe2/pages/widgets/common.dart';

class AuthorPageEntry extends PageEntry<Author, AuthorsPage, AuthorEntry> {
  const AuthorPageEntry(Key? key, PageChangeAction<Author> pageChangeAction,
      ToEntryTransformer<Author, AuthorEntry> toEntryTransformer)
      : super(key, "Authors", pageChangeAction, toEntryTransformer);
}
