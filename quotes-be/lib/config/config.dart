import 'dart:io';
import 'dart:async';
import 'dart:convert';

class PostgresConfig {
  String _host, _database, _user, _password;
  int _port, _reconnectDelaySec;

  PostgresConfig(this._host, this._port, this._database, this._user, this._password, this._reconnectDelaySec);

  PostgresConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['database'], json['user'], json['password'], json['reconnectDelaySec']);

  String get host => _host;
  String get database => _database;
  String get user => _user;
  String get password => _password;
  int get reconnectDelaySec => _reconnectDelaySec;
  int get port => _port;
}

class ElasticsearchConfig {
  String _host, _authorsIndex, _booksIndex, _quotesIndex;
  int _port, _reconnectDelaySec;

  ElasticsearchConfig(
      this._host, this._port, this._authorsIndex, this._booksIndex, this._quotesIndex, this._reconnectDelaySec);

  ElasticsearchConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['authorsIndex'], json['booksIndex'], json['quotesIndex'],
            json['reconnectDelaySec']);

  String get host => _host;
  String get authorsIndex => _authorsIndex;
  String get booksIndex => _booksIndex;
  String get quotesIndex => _quotesIndex;
  int get reconnectDelaySec => _reconnectDelaySec;
  int get port => _port;
}

class ServerConfig {
  String _host;
  int _port;

  ServerConfig(this._host, this._port);

  ServerConfig.fromJson(Map<String, dynamic> json) : this(json['host'], json['port']);

  String get host => _host;
  int get port => _port;
}

Future<Config> readConfig(String path) =>
    File(path).readAsString().then((str) => jsonDecode(str)).then((json) => Config.fromJson(json));

class Config {
  ElasticsearchConfig _elasticsearch;
  PostgresConfig _postgres;
  ServerConfig _server;

  Config(this._elasticsearch, this._postgres, this._server);

  Config.fromJson(Map<String, dynamic> json)
      : this(ElasticsearchConfig.fromJson(json['elasticsearch']), PostgresConfig.fromJson(json['postgres']), ServerConfig.fromJson(json['server']));

  ElasticsearchConfig get elasticsearch => _elasticsearch;
  PostgresConfig get postgres => _postgres;
  ServerConfig get server => _server;
}