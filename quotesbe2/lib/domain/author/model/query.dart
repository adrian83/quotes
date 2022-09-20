import 'package:quotesbe2/domain/common/model.dart';

class FindAuthorQuery {
  final String authorId;

  FindAuthorQuery(this.authorId);

  @override
  String toString() => "FindAuthorQuery [authorId: $authorId]";
}

class DeleteAuthorQuery {
  final String authorId;

  DeleteAuthorQuery(this.authorId);

  @override
  String toString() => "DeleteAuthorQuery [authorId: $authorId]";
}

class ListAuthorsQuery {
  late PageRequest pageRequest;

  ListAuthorsQuery(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsQuery [pageRequest: $pageRequest]";
}

class ListEventsByAuthorQuery {
  final String authorId;
  final PageRequest pageRequest;

  ListEventsByAuthorQuery(this.authorId, this.pageRequest);

  @override
  String toString() =>
      "ListEventsByAuthorQuery [authorId: $authorId, pageRequest: $pageRequest]";
}
