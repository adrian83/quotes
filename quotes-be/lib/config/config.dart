import 'dart:io';
import 'dart:convert';

class ElasticsearchConfig {
  String host;
  String authorsIndex, booksIndex, quotesIndex;
  String authorEventsIndex, bookEventsIndex, quoteEventsIndex;
  int port;

  ElasticsearchConfig(
      this.host, this.port, this.authorsIndex, this.booksIndex, this.quotesIndex, this.authorEventsIndex, this.bookEventsIndex, this.quoteEventsIndex);

  ElasticsearchConfig.fromJson(Map<String, dynamic> json)
      : this(json['host'], json['port'], json['authorsIndex'], json['booksIndex'], json['quotesIndex'], json['authorEventsIndex'], json['bookEventsIndex'],
            json['quoteEventsIndex']);
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
  ServerConfig server;

  Config(this.elasticsearch, this.server);

  Config.fromJson(Map<String, dynamic> json) : this(ElasticsearchConfig.fromJson(json['elasticsearch']), ServerConfig.fromJson(json['server']));
}
