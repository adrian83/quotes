import 'package:flutter/material.dart';

abstract class EntityForm<T> {
  Form createForm(BuildContext context, Function()? action);

  T createEntity();

  void dispose();
}
