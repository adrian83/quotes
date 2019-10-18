# QUOTES
Simple CRUD application. Application written with: Dart 2.5, AngularDart 6, Elasticsearch 6.4, Postgres 11.1

### Running

#### Short version
1. Run docker-compose up
2. Navigate in brawser to localhost:8080

#### Longer version
1. Start infrastructure (Elasticsearch and Postgres):
    * Start images: `dart quotes-be/dev.dart run-infra`
    * Create DB schema: `dart quotes-be/dev.dart init-db <postgres_container_name>`
2. Start backend: 
    * Navigate to backend directory: `cd quotes-be`
    * Download dependencies: `pub get`
    * Start application: `dart bin/run_app.dart infra/local.json`
3. Start frontend:
    * Navigate to frontend directory: `cd quotes-fe`
    * Download dependencies: `pub get`
    * Build application: `webdev build`
    * Start application: `pub run build_runner build --delete-conflicting-outputs`
4. Navigate in brawser to localhost:8080



### MISC
1. In case of problem with running Elsticsearch docker image please run: `sudo sysctl -w vm.max_map_count=262144`
2. Format code with dartfmt: `dartfmt -w -l 160 --fix .`
 