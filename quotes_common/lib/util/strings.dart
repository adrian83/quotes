String? shorten(String? txt, int len) {
  if (txt == null) return null;
  return txt.length > len ? "${txt.substring(0, len).trim()}..." : txt;
}
