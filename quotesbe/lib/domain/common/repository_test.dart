import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:test/test.dart";

import 'package:quotesbe/domain/common/repository.dart';
import 'package:quotesbe/storage/elasticsearch/document.dart';
import 'package:quotesbe/storage/elasticsearch/store.dart';
import 'package:quotesbe/storage/elasticsearch/response.dart';
import 'package:quotesbe/domain/common/repository_test.mocks.dart';

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

Decoder<TestEntity> testEntityDecoder =
    (Map<String, dynamic> json) => TestEntity(json["id"], json["name"]);

@GenerateMocks([ESStore<TestEntity>])
void main() {
  test("save should persist entity", () async {
    // given
    ESStore<TestEntity> storeMock = MockESStore<TestEntity>();
    Repository<TestEntity> repository =
        Repository(storeMock, testEntityDecoder);

    var entity = TestEntity("abc-def", "Shakespear");
    var indexingResult =
        IndexResult("test-index", "entity", "abc-def", "INDEXED", 1);

    when(storeMock.index(entity)).thenAnswer((_) async => indexingResult);

    // when
    await repository.save(entity);

    // then
    verify(storeMock.index(entity));
  });

  test("save should return failed Future if ES Store throws exception",
      () async {
    // given
    ESStore<TestEntity> storeMock = MockESStore<TestEntity>();
    Repository<TestEntity> repository =
        Repository(storeMock, testEntityDecoder);

    var entity = TestEntity("abc-def", "Shakespear");

    when(storeMock.index(entity))
        .thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.save(entity), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(storeMock.index(entity));
  });

/*
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
  */
}
