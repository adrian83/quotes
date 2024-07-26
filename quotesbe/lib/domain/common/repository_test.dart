import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:test/test.dart";

import 'package:quotesbe/domain/common/repository.dart';
import 'package:quotesbe/storage/elasticsearch/document.dart';
import 'package:quotesbe/storage/elasticsearch/store.dart';
import 'package:quotesbe/storage/elasticsearch/response.dart';
import 'package:quotesbe/domain/common/repository_test.mocks.dart';

class TestEntity extends Document {
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

@GenerateMocks([ESStore<TestEntity>])
void main() {
  test("save should persist entity", () async {
    // given
    ESStore<TestEntity> storeMock = MockESStore<TestEntity>();
    Repository<TestEntity> repository = Repository(storeMock, testEntityDecoder);

    var entity = TestEntity("abc-def", "Shakespear");
    var indexingResult = IndexResult("test-index", "entity", "abc-def", "INDEXED", 1);

    when(storeMock.index(entity)).thenAnswer((_) async => indexingResult);

    // when
    await repository.save(entity);

    // then
    verify(storeMock.index(entity));
  });

  test("save should return failed Future if ES Store throws exception", () async {
    // given
    ESStore<TestEntity> storeMock = MockESStore<TestEntity>();
    Repository<TestEntity> repository = Repository(storeMock, testEntityDecoder);

    var entity = TestEntity("abc-def", "Shakespear");

    when(storeMock.index(entity)).thenAnswer((_) => Future.error(StateError("exception")));

    // when
    expect(repository.save(entity), throwsA(const TypeMatcher<StateError>()));

    // the
    verify(storeMock.index(entity));
  });
}
