import 'dart:io';
import 'dart:async';

import 'config/config.dart';

const elasticsearchVersion = "6.4.2";
const configPath = "./config/local.json";
const mappingsPath = "./config/es_mapping.json";

class Command {
  String _app;
  List<String> _params;

  Command(this._app, this._params);

  Future<void> exec() async {
    Process.run(_app, _params).then((ProcessResult results) {
      print(results.stdout);
    });
  }
}

void printMenu() {
  print("---- menu -----");
}

Future<bool> createIndex(
    ElasticsearchConfig esConfig, String mappingsPath) async {
  var mappings = await new File(mappingsPath).readAsString();
  HttpClientRequest request =
      await HttpClient().put(esConfig.host, esConfig.port, esConfig.index)
        ..headers.contentType = ContentType.json
        ..write(mappings);
  HttpClientResponse response = await request.close();
  return response.statusCode == 200;
}

Future<bool> indexExists(ElasticsearchConfig esConfig) async {
  HttpClientRequest request =
      await HttpClient().head(esConfig.host, esConfig.port, esConfig.index);
  HttpClientResponse response = await request.close();
  return response.statusCode == 200;
}

main(List<String> args) async {
  if (args.length == 0) {
    printMenu();
    return;
  }

  String cmd = args[0];
  switch (cmd) {
    case 'run-docker':
      await new Command("systemctl", ["start", "docker"]).exec();
      break;
    case 'run-infra':
      await new Command("docker", [
        "pull",
        "docker.elastic.co/elasticsearch/elasticsearch:$elasticsearchVersion"
      ]).exec();
      await new Command("docker", [
        "run",
        "-d",
        "docker.elastic.co/elasticsearch/elasticsearch:$elasticsearchVersion"
      ]).exec();
      break;
    case 'es-init':

      Config config = await readConfig(configPath);
      var exists = await indexExists(config.elasticsearch);
      if (!exists) {
        await createIndex(config.elasticsearch, mappingsPath);
      }

      break;
    case 'DENIED':
      print(args);
      break;
    case 'OPEN':
      print(args);
      break;
    default:
      printMenu();
      return;
  }

//systemctl start docker
//docker pull docker.elastic.co/elasticsearch/elasticsearch:6.4.2
//  docker run -d docker.elastic.co/elasticsearch/elasticsearch:6.4.2

  // List all files in the current directory in UNIX-like systems.
  //Process.run('ls', ['-l']).then((ProcessResult results) {
  //  print(results.stdout);
//  });

//var commands = [
//  new Command("systemctl", ["start", "docker"]),
//  new Command("systemctl", ["start", "docker"]),
//]
}
