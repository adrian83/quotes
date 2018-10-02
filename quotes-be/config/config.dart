import 'dart:io';
import 'dart:async';
import 'dart:convert';
class ElasticsearchConfig {
  String _host, _index;
  int _port;

  ElasticsearchConfig(this._host, this._port, this._index);

  factory ElasticsearchConfig.fromJson(Map<String, dynamic> json) =>
      new ElasticsearchConfig(json['host'], json['port'], json['index']);

  String get host => _host;
  String get index => _index;
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
      new Config(json['elasticsearch']);

  ElasticsearchConfig get elasticsearch => _elasticsearch;
}
