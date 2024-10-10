import 'package:test/test.dart';


void main() {
  group('A group of tests', () {
    final a = 5;

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(a, isNotNull);
    });
  });
}
