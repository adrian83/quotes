# QUOTES
Simple CRUD application written in: Dart 2.5, AngularDart 6, Elasticsearch 6.4, Postgres 11.1.


## Running

### Running with docker compose

#### Prerequisites
- Docker
- Docker Compose

#### Steps
1. Run `docker-compose up`
2. Navigate in browser to `localhost:8080`
3. (Optional) Put some content into database `make be-init`

### Running locally

#### Prerequisites
- Docker
- Dart
- Webdev

#### Steps
1. Start infrastructure (Elasticsearch and Postgres): `make deps`
2. Start backend: `make be-all`
3. Start frontend: `make fe-all`
4. Navigate in browser to `localhost:8080`


### Misc
1. In case of problem with running Elsticsearch docker image please run: `sudo sysctl -w vm.max_map_count=262144`
