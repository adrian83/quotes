import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_common/domain/page.dart';

class FindAuthorQuery {
  final String authorId;

  FindAuthorQuery(this.authorId);
  @override
  String toString() => "FindAuthorQuery [authorId: $authorId]";
}

class DeleteAuthorQuery extends FindAuthorQuery {
  DeleteAuthorQuery(super.authorId);

  @override
  String toString() => "DeleteAuthorQuery [authorId: $authorId]";
}

class ListAuthorsQuery {
  late final PageRequest pageRequest;

  ListAuthorsQuery(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsQuery [$pageRequestLabel: $pageRequest]";
}

class ListEventsByAuthorQuery extends FindAuthorQuery {
  final PageRequest pageRequest;

  ListEventsByAuthorQuery(super.authorId, this.pageRequest);

  @override
  String toString() => "ListEventsByAuthorQuery [authorId: $authorId, $pageRequestLabel: $pageRequest]";
}
