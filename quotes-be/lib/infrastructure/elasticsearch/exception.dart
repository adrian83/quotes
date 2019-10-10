class IndexingFailedException implements Exception {
  String _msg;

  IndexingFailedException(this._msg);

  String get message => this._msg;
}

class DocUpdateFailedException implements Exception {}

class DocFindFailedException implements Exception {}
