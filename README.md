# QUOTES
Simple CRUD application written in: Dart 3.3, Flutter 3.19 and Elasticsearch 7.12.


## Running

### Running with docker compose

#### Prerequisites
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

#### Steps
1. Run `docker-compose up`
2. Navigate in browser to `localhost:8000`
3. (Optional) Put some content into database `make be-init`

### Running locally

#### Prerequisites
- Docker
- Dart

#### Steps
1. Start infrastructure (Elasticsearch): `make deps`
2. Start backend: `make be-all`
3. Start frontend: `make fe-all`
4. (Optional) Put some content into Elasticsearch `make be-init`
5. Navigate in browser to `localhost:8080`


### Misc
1. In case of problem with running Elsticsearch docker image please run: `sudo sysctl -w vm.max_map_count=262144`
