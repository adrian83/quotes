import 'dart:io';
import 'dart:async';
import 'dart:convert';
class ElasticsearchConfig {
  String _host, _authorsIndex, _booksIndex;
  int _port;

  ElasticsearchConfig(this._host, this._port, this._authorsIndex, this._booksIndex);

  factory ElasticsearchConfig.fromJson(Map<String, dynamic> json) =>
      new ElasticsearchConfig(json['host'], json['port'], json['authorsIndex'], json['booksIndex']);

  String get host => _host;
  String get authorsIndex => _authorsIndex;
  String get booksIndex => _booksIndex;
  int get port => _port;
}

Future<Config> readConfig(String path) async {
  var content = new File(path).readAsString();
  var json = jsonDecode(await content);
  return Config.fromJson(json);
}

class Config {
  ElasticsearchConfig _elasticsearch;

  Config(this._elasticsearch);

  factory Config.fromJson(Map<String, dynamic> json) =>
      new Config(new ElasticsearchConfig.fromJson(json['elasticsearch']));

  ElasticsearchConfig get elasticsearch => _elasticsearch;
}
