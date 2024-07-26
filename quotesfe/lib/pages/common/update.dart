import 'package:flutter/material.dart';

import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/pages/common/new.dart';
import 'package:quotesfe/widgets/common/entity_form.dart';

abstract class UpdatePage<T extends Entity, F extends EntityForm<T>> extends NewPage<T, F> {
  const UpdatePage(Key? key, String title) : super(key, title);

  @override
  F createEntityForm(BuildContext context, T? entity);

  @override
  Future<T> persist(T entity);

  @override
  bool hideFormOnSuccess() => false;
}
