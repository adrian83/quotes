
abstract class ESDocument {
  String getId();
  Map toJson();
}

class UpdateDoc {
  bool _docAsUpsert = true, _detectNoop = false;
  ESDocument _doc;

  UpdateDoc(this._doc);

  Map toJson() {
    var map = Map<String, Object>();
    map["doc"] = _doc.toJson();
    map["doc_as_upsert"] = _docAsUpsert;
    map["detect_noop"] = _detectNoop;
    return map;
  }

}
