class Config {
  final String apiHost;

  Config(this.apiHost);
}

final Config localConfig = Config("http://localhost:5050");

final Config composeConfig = Config("http://localhost:5050");

Config forEnvironment(String? env) {
  switch (env) {
    case 'local':
      return localConfig;
    case 'compose':
      return composeConfig;
  }
  throw ArgumentError("unknown env $env");
}
