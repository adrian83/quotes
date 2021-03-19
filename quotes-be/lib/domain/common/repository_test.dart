import 'dart:async';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

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
/*
  test("save should persist entity", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");

    when(storeMock.index(entity)).thenAnswer((_) => Future.value());

    // when
    await repository.save(entity);

    // then
    verify(storeMock.index(entity));
  });

  test("save should return failed Future if store throws exception", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    when(storeMock.index(entity)).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.save(entity), throwsStateError);

    // the
    verify(storeMock.index(entity));
  });

  test("find should return entity", () async {
    // given
    var entity = TestEntity("abc-def", "Shakespear");
    var entityJson = {"id": entity.id, "name": entity.name};

    var getResult = GetResult("author", "doc", "xyz-hij", 1, true, entityJson);

    when(storeMock.get("abc-def")).thenAnswer((_) => Future.value(getResult));

    // when
    var result = await repository.find("abc-def");

    // then
    verify(storeMock.get("abc-def"));

    assertEntity(entity, result);
  });
  */
}
