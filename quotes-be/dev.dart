import 'dart:io';
import 'dart:async';

import 'config/config.dart';

const elasticsearchVersion = "6.4.1";
const configPath = "./config/local.json";
const mappingsPath = "./config/es_mapping.json";

const String runDocker = 'run-docker';
const String runInfrastructure = 'run-infra';
const String initElasticsearch = 'es-init';

void printMenu() {
  print("");
  print("------------ MENU ------------");
  print("$runDocker - runs docker daemon (systemd)");
  print(
      "$runInfrastructure - runs infrastructure (docker image with elasticsearch:$elasticsearchVersion)");
  print("$initElasticsearch - creates index and uploads mappings");
  print("");
}

class Command {
  String _app;
  List<String> _params;

  Command(this._app, this._params);

  void exec() {
    var cmd = "$_app ${_params.join(' ')}";
    print("Starting: $cmd");
    ProcessResult result = Process.runSync(_app, _params);
    print("STDOUT: \n ${result.stdout}");
    print("Executed: $cmd");
  }
}

Future<bool> createIndex(
    ElasticsearchConfig esConfig, String mappingsPath) async {
  String mappings = await File(mappingsPath).readAsString();
  return HttpClient()
      .put(esConfig.host, esConfig.port, esConfig.index)
      .then((req) {
        return req
          ..headers.contentType = ContentType.json
          ..write(mappings);
      })
      .then((req) => req.close())
      .then((resp) {
        var ok = resp.statusCode == 200;
        print("Index created: $ok");
        return ok;
      });
}

Future<bool> indexExists(ElasticsearchConfig esConfig) async {
  return HttpClient()
      .head(esConfig.host, esConfig.port, esConfig.index)
      .then((req) => req.close())
      .then((resp) {
    var ok = resp.statusCode == 200;
    print("Index exists: $ok");
    return ok;
  });
}

void main(List<String> args) async {
  if (args.length == 0) {
    printMenu();
    return;
  }

  String cmd = args[0];
  switch (cmd) {
    case runDocker:
      await new Command("systemctl", ["start", "docker"]).exec();
      break;

    case runInfrastructure:
      //Config config = await readConfig(configPath);
/*
      new Command("docker", [
        "pull",
        "docker.elastic.co/elasticsearch/elasticsearch:$elasticsearchVersion"
      ]).exec();
*/
// docker run -d --name elasticsearch3 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:6.4.1
      new Command("docker", [
        "run",
        "-d",
        "--name",
        "es",
        "-p",
        "9200:9200",
        "-p",
        "9300:9300",
        "-e",
        "\"discovery.type=single-node\"",
        "elasticsearch:$elasticsearchVersion"
      ]).exec();

      break;

    case initElasticsearch:
      Config config = await readConfig(configPath);
      await indexExists(config.elasticsearch).then((exists) async => exists
          ? true
          : await createIndex(config.elasticsearch, mappingsPath));
      break;
    default:
      printMenu();
      return;
  }

  //exit(1);
}
