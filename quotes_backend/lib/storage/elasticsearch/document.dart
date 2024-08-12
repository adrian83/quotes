abstract class Document {
  String getId();
  Map<dynamic, dynamic> toSave();
  Map<dynamic, dynamic> toUpdate();
  Map<dynamic, dynamic> toJson();
}

class UpdateDoc {
  final bool _docAsUpsert = true, _detectNoop = false;
  final Map<dynamic, dynamic> _doc;

  UpdateDoc(this._doc);

  Map toJson() => {"doc": _doc, "doc_as_upsert": _docAsUpsert, "detect_noop": _detectNoop};
}
