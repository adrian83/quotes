import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/author/model/entity.dart';

class NewAuthorCommand {
  final String name, description;

  NewAuthorCommand(this.name, this.description);

  Author toAuthor() => Author(
        const Uuid().v4(),
        name,
        description,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateAuthorCommand {
  final String id, name, description;

  UpdateAuthorCommand(this.id, this.name, this.description);

  Author toAuthor() =>
      Author(id, name, description, DateTime.now(), DateTime.now());
}
