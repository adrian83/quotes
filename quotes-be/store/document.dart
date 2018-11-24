abstract class ESDocument {
  static final String created = "created",
      modified = "modified",
      deleted = "deleted";

  String _docId, _operation;

  ESDocument(this._docId, this._operation);

  String get docId => _docId;

  Map toJson() => {"docId": _docId, "operatio": _operation};
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  ESDocument _doc;

  UpdateDoc(this._doc);

  Map toJson() => {
        "doc": _doc.toJson(),
        "doc_as_upsert": _docAsUpsert,
        "detect_noop": _detectNoop
      };
}
