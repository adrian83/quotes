import 'package:flutter/material.dart';

import 'package:quotes_frontend/widgets/author/list_entry.dart';
import 'package:quotes_frontend/widgets/page_entry.dart';
import 'package:quotes_common/domain/author.dart';

class AuthorPageEntry extends PageEntry<Author, AuthorsPage, AuthorEntry> {
  const AuthorPageEntry(Key? key, PageChangeAction<Author> pageChangeAction, ToEntryTransformer<Author, AuthorEntry> toEntryTransformer, ErrorHandler errorHandler)
      : super(key, "Authors", pageChangeAction, toEntryTransformer, errorHandler);
}
