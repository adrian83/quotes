
abstract class ESDocument {
  String getId();
  Map toJson();
}

class UpdateDoc {
  bool _docAsUpsert = true;
  ESDocument _doc;

  UpdateDoc(this._doc);

  Map toJson() {
    var map = new Map<String, Object>();
    map["doc"] = _doc.toJson();
    map["doc_as_upsert"] = _docAsUpsert;
    return map;
  }

}
