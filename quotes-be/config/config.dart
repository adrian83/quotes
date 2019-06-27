import 'dart:io';
import 'dart:async';
import 'dart:convert';

class PostgresConfig {
  String _host, _database, _user, _password;
  int _port, _reconnectDelaySec;

  PostgresConfig(
      this._host, this._port, this._database, this._user, this._password, this._reconnectDelaySec);

  PostgresConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['database'], json['user'],
            json['password'], json['reconnectDelaySec']);

  String get host => _host;
  String get database => _database;
  String get user => _user;
  String get password => _password;
  int get reconnectDelaySec => _reconnectDelaySec;
  int get port => _port;
}

class ElasticsearchConfig {
  String _host, _authorsIndex, _booksIndex, _quotesIndex;
  int _port;

  ElasticsearchConfig(this._host, this._port, this._authorsIndex,
      this._booksIndex, this._quotesIndex);

  ElasticsearchConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['authorsIndex'],
            json['booksIndex'], json['quotesIndex']);

  String get host => _host;
  String get authorsIndex => _authorsIndex;
  String get booksIndex => _booksIndex;
  String get quotesIndex => _quotesIndex;
  int get port => _port;
}

Future<Config> readConfig(String path) => File(path)
    .readAsString()
    .then((str) => jsonDecode(str))
    .then((json) => Config.fromJson(json));

class Config {
  ElasticsearchConfig _elasticsearch;
  PostgresConfig _postgres;

  Config(this._elasticsearch, this._postgres);

  Config.fromJson(Map<String, dynamic> json)
      : this(ElasticsearchConfig.fromJson(json['elasticsearch']),
            PostgresConfig.fromJson(json['postgres']));

  ElasticsearchConfig get elasticsearch => _elasticsearch;
  PostgresConfig get postgres => _postgres;
}
