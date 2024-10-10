import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:test/test.dart";

import 'package:quotes_backend/domain/author/model/entity.dart';
import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_backend/domain/author/repository.dart';
import 'package:quotes_backend/domain/author/repository_test.mocks.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/store.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/response.dart';
import 'package:quotes_common/domain/page.dart';

var author1Json = {
  "id": "rwe-wer",
  "name": "John",
  "description": "this is John",
  "modifiedUtc": "2011-10-05T14:48:00.000Z",
  "createdUtc": "2011-10-05T14:48:00.000Z",
};

var author2Json = {
  "id": "hgf-nbv",
  "name": "Paul",
  "description": "this is Paul",
  "modifiedUtc": "2011-10-05T14:48:00.000Z",
  "createdUtc": "2011-10-05T14:48:00.000Z",
};

@GenerateMocks([ESStore<AuthorDocument>])
void main() {
  test("should find page of authors", () async {
    // given
    var authorStoreMock = MockESStore<AuthorDocument>();
    var authorRepository = AuthorRepository(authorStoreMock);

    var request = SearchQuery("test", PageRequest(0, 5));

    var hit1 = SearchHit("author", "doc", "1", 3.4, author1Json);
    var hit2 = SearchHit("author", "doc", "2", 1.2, author2Json);
    var hits = SearchHits(HitsTotal(2, "relation"), 3.4, [hit1, hit2]);
    var searchResult = SearchResult(false, 11, hits);

    when(authorStoreMock.list(any)).thenAnswer((_) async => searchResult);

    // when
    var page = await authorRepository.findAuthors(request);

    expect(page.elements.length, equals(2));
  });
}
