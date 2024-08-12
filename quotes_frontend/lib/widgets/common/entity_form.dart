import 'package:flutter/material.dart';

abstract class EntityForm<T> {
  Form createForm(BuildContext context, Function()? action) => const Form(child: Text(""));

  T createEntity();

  void dispose();
}
