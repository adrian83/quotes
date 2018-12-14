import 'dart:io';

import 'config/config.dart';


const esVersion = "6.4.1";
const configPath = "./infra/local.json";

const postgresVersion = "11.1";
const postgresEnvTemplatePath = "./infra/env.db.template";
const postgresEnvPath = "./infra/env.db";
const postgresInitScript = "./infra/db.sql";

const runDocker = 'run-docker';
const runInfrastructure = 'run-infra';
const initDatabase = 'init-db';

void printMenu() {
  print("");
  print("------------ MENU ------------");
  print("$runDocker  \t- runs docker daemon (systemd)");
  print("$runInfrastructure \t- runs infrastructure");
  print("\t\t\t- docker image with elasticsearch:$esVersion");
  print("\t\t\t- docker image with postgres:$postgresVersion");
  print("$initDatabase \t- initialize database");
  print("");
}

class Command {
  String _app;
  List<String> _params;

  Command(String cmdString){
    var words = cmdString.split(" ")
    ..removeWhere((w) => w.length == 0);
    _app = words[0];
    _params = words.sublist(1);
  }

  void exec() {
    var cmd = "$_app ${_params.join(' ')}";
    print("Starting: $cmd");
    ProcessResult result = Process.runSync(_app, _params);
    print("STDOUT: \n${result.stdout}");
    print("STDERR: \n${result.stderr}");
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
      await Command("systemctl start docker").exec();
      break;

    case runInfrastructure:

      Command("docker run -d -p 9200:${config.elasticsearch.port} -p 9300:9300 -e \"discovery.type=single-node\" elasticsearch:$esVersion").exec();

      await File(postgresEnvTemplatePath)
          .readAsString()
          .then((content) => content
              .replaceAll("--db-user--", config.postgres.user)
              .replaceAll("--db-pass--", config.postgres.password)
              .replaceAll("--db-name--", config.postgres.database))
          .then((content) => File(postgresEnvPath).writeAsStringSync(content))
          .catchError((e) => print(e));

      Command("docker run -p 5432:${config.postgres.port} --env-file=$postgresEnvPath -d postgres:$postgresVersion").exec();

      break;

    case initDatabase:
      if (args.length < 2) {
        print("Please provide Postgres container name (docker ps)");
        return;
      }

      var containerName = args[1];

      Command("docker cp $postgresInitScript $containerName:/file.sql").exec();

      Command("docker exec $containerName psql ${config.postgres.database} ${config.postgres.user} -f /file.sql").exec();

      break;

    default:
      printMenu();
      return;
  }

}
