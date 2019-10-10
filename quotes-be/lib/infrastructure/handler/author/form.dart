import '../../web/param.dart';
import '../../web/form.dart';
import '../../../common/tuple.dart';

class NewAuthorForm {
  String name, description;

  NewAuthorForm(this.name, this.description);
}

var minNameLen = 1;
var maxNameLen = 200;
var invalidNameViolation = Violation("name", "Name length should be between $minNameLen and $maxNameLen");

var minDescriptionLen = 1;
var maxDescriptionLen = 5000;
var invalidDescViolation = Violation("description", "Description length should be between $minDescriptionLen and $maxDescriptionLen");

class NewAuthorFormParser extends FormParser<NewAuthorForm> {
  Tuple2<NewAuthorForm, List<Violation>> parse(Map rawForm) {
    List<Violation> violations = [];
    var name, description;

    var nameObj = rawForm["name"];
    if (!isString(nameObj)) {
      violations.add(invalidNameViolation);
    } else {
      name = nameObj.toString();
      if (shorter(name, minNameLen) || longer(name, maxNameLen)) {
        violations.add(invalidNameViolation);
      }
    }

    var descObj = rawForm["description"];
    if (!isString(descObj)) {
      violations.add(invalidDescViolation);
    } else {
      description = descObj.toString();
      if (shorter(description, minDescriptionLen) || longer(description, maxDescriptionLen)) {
        violations.add(invalidDescViolation);
      }
    }

    if (violations.length > 0) {
      return Tuple2(null, violations);
    }

    return Tuple2(NewAuthorForm(name, description), null);
  }
}
