import 'dart:io';
import 'dart:async';
import 'dart:convert';

class PostgresConfig {
  String host, database, user, password;
  int port, reconnectDelaySec;

  PostgresConfig(this.host, this.port, this.database, this.user, this.password, this.reconnectDelaySec);

  PostgresConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['database'], json['user'], json['password'], json['reconnectDelaySec']);
}

class ElasticsearchConfig {
  String host, authorsIndex, booksIndex, quotesIndex;
  int port, reconnectDelaySec;

  ElasticsearchConfig(this.host, this.port, this.authorsIndex, this.booksIndex, this.quotesIndex, this.reconnectDelaySec);

  ElasticsearchConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['authorsIndex'], json['booksIndex'], json['quotesIndex'], json['reconnectDelaySec']);
}

class ServerConfig {
  String host;
  int port;

  ServerConfig(this.host, this.port);

  ServerConfig.fromJson(Map<String, dynamic> json) : this(json['host'], json['port']);
}

Future<Config> readConfig(String path) => File(path).readAsString().then((str) => jsonDecode(str)).then((json) => Config.fromJson(json));

class Config {
  ElasticsearchConfig elasticsearch;
  PostgresConfig postgres;
  ServerConfig server;

  Config(this.elasticsearch, this.postgres, this.server);

  Config.fromJson(Map<String, dynamic> json)
      : this(ElasticsearchConfig.fromJson(json['elasticsearch']), PostgresConfig.fromJson(json['postgres']), ServerConfig.fromJson(json['server']));
}
