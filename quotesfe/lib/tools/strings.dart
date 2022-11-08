import 'dart:math';

String? shorten(String? txt, int len) {
  if (txt == null) return null;
  return txt.length > len ? txt.substring(0, len).trim() + "..." : txt;
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String random(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String random12(int length) => random(12);
