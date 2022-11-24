bool emptyString(String? text) => text == null || text.isEmpty;

class Violation {
  final String field, message;

  Violation(this.field, this.message);

  Map toJson() => {'field': field, 'message': message};
}

class ValidationRule {
  final String field, errorMessage;
  final Function validator;

  ValidationRule(this.field, this.errorMessage, this.validator);
}

List<Violation> validate(List<ValidationRule> rules, Map json) {
  var violations = <Violation>[];

  for (var rule in rules) {
    var value = json[rule.field];
    var notOk = rule.validator(value);
    if (notOk) {
      violations.add(Violation(rule.field, rule.errorMessage));
    }
  }

  return violations;
}
