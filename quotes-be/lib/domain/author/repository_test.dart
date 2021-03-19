import 'package:mockito/mockito.dart';

import 'model.dart';
import '../../infrastructure/elasticsearch/store.dart';

class AuthorStoreMock extends Mock implements ESStore<Author> {}

void main() {
  //var authorStoreMock = AuthorStoreMock();
  //var authorRepository = AuthorRepository(authorStoreMock);

// test("save should find page of authors", () async {
// // given
// var request = SearchEntityRequest("test", 0, 5);

// var hit1 = SearchHit ("author", "doc", "1", 3.4, {"id": "rwe-wer", "name": "John"});
// var hit2 = SearchHit ("author", "doc", "2", 1.2, {"id": "rty-ghj", "name": "Paul"});
// var hits = SearchHits(2, 3.4, [hit1, hit2]);
// var searchResult = SearchResult(false, 11, hits);

// //when(authorStoreMock.list( ?? )).thenAnswer((realInvocation) => Future.value(searchResult));

// // when
// var page = authorRepository.findAuthors(request);

// });
}
