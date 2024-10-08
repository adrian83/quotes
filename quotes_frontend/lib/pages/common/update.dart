import 'package:flutter/material.dart';

import 'package:quotes_frontend/pages/common/new.dart';
import 'package:quotes_frontend/widgets/common/entity_form.dart';
import 'package:quotes_common/domain/entity.dart';

abstract class UpdatePage<T extends Entity, F extends EntityForm<T>> extends NewPage<T, F> {
  const UpdatePage(super.key, super.title);

  @override
  F createEntityForm(BuildContext context, T? entity);

  @override
  Future<T> persist(T entity);

  @override
  bool hideFormOnSuccess() => false;
}
