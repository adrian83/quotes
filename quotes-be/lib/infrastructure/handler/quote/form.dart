import '../../web/param.dart';
import '../../web/form.dart';
import '../../../common/tuple.dart';

class NewQuoteForm {
  String text;

  NewQuoteForm(this.text);
}

var minTextLen = 1;
var maxTextLen = 5000;
var invalidTextViolation = Violation("text", "Text length should be between $minTextLen and $maxTextLen");

class NewQuoteFormParser extends FormParser<NewQuoteForm> {
  Tuple2<NewQuoteForm, List<Violation>> parse(Map rawForm) {
    List<Violation> violations = [];
    var text;

    var textObj = rawForm["text"];
    if (!isString(textObj)) {
      violations.add(invalidTextViolation);
    } else {
      text = textObj.toString();
      if (shorter(text, minTextLen) || longer(text, maxTextLen)) {
        violations.add(invalidTextViolation);
      }
    }

    if (violations.length > 0) {
      return Tuple2(null, violations);
    }

    return Tuple2(NewQuoteForm(text), null);
  }
}
