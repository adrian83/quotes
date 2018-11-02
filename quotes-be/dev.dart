import 'dart:io';

import 'config/config.dart';

const elasticsearchVersion = "6.4.1";
const configPath = "./config/local.json";
const mappingsPath = "./config/es_mapping.json";

const String runDocker = 'run-docker';
const String runInfrastructure = 'run-infra';

void printMenu() {
  print("");
  print("------------ MENU ------------");
  print("$runDocker - runs docker daemon (systemd)");
  print(
      "$runInfrastructure - runs infrastructure (docker image with elasticsearch:$elasticsearchVersion)");
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

void main(List<String> args) async {
  if (args.length == 0) {
    printMenu();
    return;
  }

  String cmd = args[0];
  switch (cmd) {
    case runDocker:
      await Command("systemctl", ["start", "docker"]).exec();
      break;

    case runInfrastructure:
      Config config = await readConfig(configPath);

// docker run -d --name elasticsearch3 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:6.4.1
       Command("docker", [
        "run",
        "-d",
        "-p",
        "9200:${config.elasticsearch.port}",
        "-p",
        "9300:9300",
        "-e",
        "\"discovery.type=single-node\"",
        "elasticsearch:$elasticsearchVersion"
      ]).exec();

      break;

    default:
      printMenu();
      return;
  }

  //exit(1);
}
