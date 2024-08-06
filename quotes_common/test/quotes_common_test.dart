import 'package:test/test.dart';

import 'package:quotes_common/quotes_common.dart';
import 'package:quotes_common/domain/author.dart';

void main() {
  group('A group of tests', () {
    final author = Author.create("Adam Mickiewicz", "Polish writer...");

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(author.id, isNotNull);
      expect(author.name, equals("Adam Mickiewicz"));
    });
  });
}
