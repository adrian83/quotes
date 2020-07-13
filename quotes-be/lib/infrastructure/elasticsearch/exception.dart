import 'response.dart';

class IndexingFailedException<T> implements Exception {
  IndexResult result;
  T document;

  IndexingFailedException(this.document, this.result);

  String toString() {
    return "IndexingFailedException [document: $document, result: $result]";
  }
}

class DocUpdateFailedException<T> implements Exception {
  UpdateResult result;
  T document;

  DocUpdateFailedException(this.document, this.result);

  String toString() {
    return "DocUpdateFailedException [document: $document, result: $result]";
  }
}

class DocFindFailedException implements Exception {
  GetResult result;
  String id;

  DocFindFailedException(this.id, this.result);

  String toString() {
    return "DocFindFailedException [document id: $id, result: $result]";
  }
}

class IndexNotFoundException implements Exception {}
