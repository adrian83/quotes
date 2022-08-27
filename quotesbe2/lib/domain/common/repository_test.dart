import "package:test/test.dart";
import 'package:mocktail/mocktail.dart';

import 'package:quotesbe2/domain/common/repository.dart';
import 'package:quotesbe2/storage/elasticsearch/document.dart';
import 'package:quotesbe2/storage/elasticsearch/store.dart';
import 'package:quotesbe2/storage/elasticsearch/response.dart';



class TestEntity with Document {
  String id, name;

  TestEntity(this.id, this.name);

  @override
  String getId() => id;
  
  @override
  Map toSave() => {"id": id, "name": name};
  
  @override
  Map toUpdate() => {"id": id, "name": name};

  @override
  Map toJson() => {"id": id, "name": name};
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

  test("save should return failed Future if ES Store throws exception", () async {
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

  test("find should return failed Future if ES Store throws exception", () async {
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
    var updateResult = UpdateResult("author", "doc", entity.id, entityJson, 1);

    when(() => storeMock.update(entity)).thenAnswer((_) => Future.value(updateResult));

    // when
    var result = await repository.update(entity);

    // then
    verify(() => storeMock.update(entity)).called(1);

    assertEntity(entity, result);
  });

  test("update should return failed Future if ES Store throws exception", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");

    when(() => storeMock.update(entity)).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.update(entity), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(() => storeMock.update(entity)).called(1);
  });

  test("delete should delete entity", () async {
    // given
    var docId = "mnb-lkj";
    var deleteResult = DeleteResult("author", "doc", docId, "DELETED", 1);

    when(() => storeMock.delete(docId)).thenAnswer((_) => Future.value(deleteResult));

    // when
    await repository.delete(docId);

    // then
    verify(() => storeMock.delete(docId)).called(1);
  });

  test("delete should return failed Future if ES store throws exception", () async {
    // given
    var docId = "mnb-lkj";

    when(() => storeMock.delete(docId)).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.delete(docId), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(() => storeMock.delete(docId)).called(1);
  });
}
