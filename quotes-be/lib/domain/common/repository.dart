import 'dart:async';

import 'package:postgres/postgres.dart';

import 'exception.dart';

typedef RowDecoder<T> = T Function(List<dynamic> row);

class Repository<T> {
  PostgreSQLConnection _connection;
  RowDecoder<T> _rowDecoder;

  Repository(this._connection, this._rowDecoder);

  PostgreSQLConnection get connection => _connection;

  Future<void> saveByStatement(String insertStatement, Map<String, Object> params) =>
      _connection.execute(insertStatement, substitutionValues: params);

  Future<T> findOneByStatement(String findStmt, Map<String, Object> params) =>
      _connection.query(findStmt, substitutionValues: params).then((List<List<dynamic>> entitiesData) {
        if (entitiesData.length == 0) throw FindFailedException();
        return _rowDecoder(entitiesData[0]);
      });

  Future<void> updateAtLeastOne(String updateStmt, Map<String, Object> params) =>
      connection.execute(updateStmt, substitutionValues: params).then((count) {
        if (count == 0) throw FindFailedException();
      });

  Future<int> deleteAll(String deleteStmt, Map<String, Object> params) =>
      connection.execute(deleteStmt, substitutionValues: params);

  Future<List<T>> listAll(String selectStmt, Map<String, Object> params) => _connection
      .query(selectStmt, substitutionValues: params)
      .then((List<List<dynamic>> entitiesData) => toEntities(entitiesData));

  Future<void> deleteAtLeastOne(String deleteStmt, Map<String, Object> params) =>
      deleteAll(deleteStmt, params).then((count) {
        if (count == 0) throw FindFailedException();
      });

  Future<int> count(String countStmt, Map<String, Object> params) =>
      connection.query(countStmt, substitutionValues: params).then((l) => l[0][0]);

  List<T> toEntities(List<List<dynamic>> entitiesData) =>
      entitiesData.map((List<dynamic> entityData) => _rowDecoder(entityData)).toList();
}
