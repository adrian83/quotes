import '../common/model.dart';

class Author extends Entity {
    String _name;

    Author(String id, this._name) : super(id);

    String get name => _name;

    Map toJson() {
      var map = super.toJson();
      map["name"] = this.name;
      return map;
    }
}
