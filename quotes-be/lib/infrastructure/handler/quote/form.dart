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
    var textObj = rawForm["text"];
    var tuple = validateText(textObj);
    var violations = tuple.e2 == null ? null : [tuple.e2];
    return Tuple2(NewQuoteForm(tuple.e1), violations);
  }
}

Tuple2<String, Violation> validateText(Object rawText) {
  if (isString(rawText)) {
    var text = rawText.toString();
    if (shorter(text, minTextLen) || longer(text, maxTextLen)) {
      return Tuple2(null, invalidTextViolation);
    }
    return Tuple2(text, null);
  }

  return Tuple2(null, invalidTextViolation);
}
