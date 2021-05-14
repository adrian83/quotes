import "package:test/test.dart";
import 'package:mocktail/mocktail.dart';

import 'repository.dart';
import '../../infrastructure/elasticsearch/document.dart';
import '../../infrastructure/elasticsearch/store.dart';
import '../../infrastructure/elasticsearch/response.dart';

class TestEntity with Document {
  String id, name;

  TestEntity(this.id, this.name);

  String getId() => this.id;
  Map<dynamic, dynamic> toJson() => {"id": id, "name": name};
}

Decoder<TestEntity> testEntityDecoder = (Map<String, dynamic> json) => TestEntity(json["id"], json["name"]);

class TestEntityStoreMock extends Mock implements ESStore<TestEntity> {}

void main() {
  ESStore<TestEntity> storeMock = TestEntityStoreMock();
  Repository<TestEntity> repository = Repository(storeMock, testEntityDecoder);

  void assertEntity(TestEntity expected, TestEntity actual) {
     expect(expected.id, equals(actual.id));
     expect(expected.name, equals(actual.name));
   }

  test("save should persist entity", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    var indexingResult = IndexResult("test-index", "entity", "abc-def", "INDEXED", 1);

    when(() => storeMock.index(entity)).thenAnswer((_) => Future.value(indexingResult));

    // when
    await repository.save(entity);

    // then
    verify(() => storeMock.index(entity)).called(1);
  });

  test("save should return failed Future if Store throws exception", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    when(() => storeMock.index(entity)).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.save(entity), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(() => storeMock.index(entity)).called(1);
  });

  test("find should return entity", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    var entityJson = {"id": entity.id, "name": entity.name};

    var getResult = GetResult("author", "doc", "xyz-hij", 1, true, entityJson);

    when(() => storeMock.get(any())).thenAnswer((_) => Future.value(getResult));

    // when
    var result = await repository.find("abc-def");

    // then
    verify(() => storeMock.get(any())).called(1);

    assertEntity(entity, result);
  });
  
  test("find should return failed Future if Store throws exception", () async {
    // given
    when(() => storeMock.get(any())).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.find("abc-poi"), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(() => storeMock.get(any())).called(1);
  });

  test("update should update entity", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    var entityJson = "{\"id\": ${entity.id}, \"name\": ${entity.name}}";

    var updateResult = UpdateResult("author", "doc", "abc-def", entityJson, 1);

    when(() => storeMock.update(entity)).thenAnswer((_) => Future.value(updateResult));

    // when
    var result = await repository.update(entity);

    // then
    verify(() => storeMock.update(entity)).called(1);

    assertEntity(entity, result);
  });

}
