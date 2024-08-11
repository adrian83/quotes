DateTime nowUtc() => DateTime.now().toUtc();

String toString(DateTime dateTime) => dateTime.toIso8601String();

DateTime fromString(String dateTimeString) => DateTime.parse(dateTimeString);
