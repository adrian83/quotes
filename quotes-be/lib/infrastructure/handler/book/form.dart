import '../../web/param.dart';
import '../../web/form.dart';
import '../../../common/tuple.dart';

class NewBookForm {
  String title, description;

  NewBookForm(this.title, this.description);
}

var minTitleLen = 1; 
var maxTitleLen = 200;
var invalidTitleViolation = Violation("title", "Title length should be between $minTitleLen and $maxTitleLen");

var minDescriptionLen = 1;
var maxDescriptionLen = 5000;
var invalidDescViolation = Violation("description", "Description length should be between $minDescriptionLen and $maxDescriptionLen");

class NewBookFormParser extends FormParser<NewBookForm> {

  Tuple2<NewBookForm, List<Violation>> parse(Map rawForm) {

    List<Violation> violations = [];
    var title, description;

    var titleObj = rawForm["title"];
    if(!isString(titleObj)){
      violations.add(invalidTitleViolation);
    } else {
      title = titleObj.toString();
      if(shorter(title, minTitleLen) || longer(title, maxTitleLen)){
        violations.add(invalidTitleViolation);
      }
    }

    var descObj = rawForm["description"];
    if(!isString(descObj)){
      violations.add(invalidDescViolation);
    } else {
      description = descObj.toString();
      if(shorter(description, minDescriptionLen) || longer(description, maxDescriptionLen)){
        violations.add(invalidDescViolation);
      }
    }

    if(violations.length > 0) {
      return Tuple2(null, violations);
    }

    return Tuple2(NewBookForm(title, description), null);
  }
}
