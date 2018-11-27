import 'dart:io';

import 'config/config.dart';

var nowMs = new DateTime.now().millisecondsSinceEpoch;

const elasticsearchVersion = "6.4.1";
const configPath = "./infra/local.json";

const postgresVersion = "11.1";
const postgresEnvTemplatePath = "./infra/env.db.template";
const postgresEnvPath = "./infra/env.db";
const postgresInitScript = "./infra/db.sql";
var postgresName = "postgresdb-$nowMs";

const containerInfo = "./infra/container";

const runDocker = 'run-docker';
const runInfrastructure = 'run-infra';
const initDatabase = 'init-db';

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

  Config config = await readConfig(configPath);

  String cmd = args[0];
  switch (cmd) {
    case runDocker:
      await Command("systemctl", ["start", "docker"]).exec();
      break;

    case runInfrastructure:

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

      await File(postgresEnvTemplatePath)
          .readAsString()
          .then((content) => content
              .replaceAll("--db-user--", config.postgres.user)
              .replaceAll("--db-pass--", config.postgres.password)
              .replaceAll("--db-name--", config.postgres.database))
          .then((content) => File(postgresEnvPath).writeAsStringSync(content))
          .catchError((e) => print(e));

      Command("docker", [
        "run",
        "--name",
        postgresName,
        "-p",
        "5432:${config.postgres.port}",
        "--env-file=$postgresEnvPath",
        "-d",
        "postgres:$postgresVersion"
      ]).exec();

      File(containerInfo).writeAsStringSync(postgresName);

      break;

    case initDatabase:

var containerName = File(containerInfo).readAsStringSync();

      // docker run --name postgres --env-file=env.db -d postgres
      Command("docker", ["cp", postgresInitScript, "$containerName:/file.sql"])
          .exec();

// docker exec vigilant_lamport psql quotes admin -f /file.sql
      Command("docker", [
        "exec",
        containerName,
        "psql",
        config.postgres.database,
        config.postgres.user,
        "-f",
        "/file.sql"
      ]).exec();

      // docker cp ./localfile.sql containername:/container/path/file.sql
      // docker exec containername -u postgresuser psql dbname postgresuser -f /container/path/file.sql
      break;
    default:
      printMenu();
      return;
  }

  //exit(1);
}
