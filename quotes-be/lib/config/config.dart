import 'dart:io';
import 'dart:async';
import 'dart:convert';

class PostgresConfig {
  String host, database, user, password;
  int port;

  PostgresConfig(this.host, this.port, this.database, this.user, this.password);

  PostgresConfig.fromJson(Map<String, dynamic> json) : this(json['host'], json['port'], json['database'], json['user'], json['password']);
}

class ElasticsearchConfig {
  String host, authorsIndex, booksIndex, quotesIndex;
  int port;

  ElasticsearchConfig(this.host, this.port, this.authorsIndex, this.booksIndex, this.quotesIndex);

  ElasticsearchConfig.fromJson(Map<String, dynamic> json) : this(json['host'], json['port'], json['authorsIndex'], json['booksIndex'], json['quotesIndex']);
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
