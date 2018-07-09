class Quote {
  Long id;
  String text;

  Quote(this.id, this.text);

  Map toJson() {
    var map = new Map<String, Object>();
    map["id"] = this.id;
    map["text"] = this.text;
    return map;
  }

  String toString() {
    return JSON.encode(this);
  }
}
