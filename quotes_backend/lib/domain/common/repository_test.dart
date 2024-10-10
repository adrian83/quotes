import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import "package:test/test.dart";

import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_backend/domain/common/repository.dart';
import 'package:quotes_backend/domain/common/repository_test.mocks.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/store.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/response.dart';
import 'package:quotes_common/util/time.dart';

class TestEntity extends EntityDocument {
  String name;

  TestEntity(String id, this.name) : super('abc', nowUtc(), nowUtc());

  @override
  String getId() => super.id;

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
