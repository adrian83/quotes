

docker:
	sudo systemctl start docker

deps:
	echo "starting elasticsearch image (version 6.4.1)"
	docker run -d -p 9200:9200 -p 9300:9300 -e \"discovery.type=single-node\" elasticsearch:6.4.1
	echo "starting postgres image (version 11.1)"
	docker run -p 5432:5432 --env-file=quotes-be/infra/env.db -d --name=quotes_postgres postgres:latest
	sleep 5
	docker cp quotes-be/infra/db.sql quotes_postgres:/file.sql
	docker exec quotes_postgres psql quotes root -f /file.sql

fe-format:
	cd quotes-fe && dartfmt -w -l 160 --fix .

fe-get:
	echo "getting frontend dependencies" 
	cd quotes-fe && pub get 

fe-build:
	echo "building frontend"
	cd quotes-fe && pub run build_runner clean
	cd quotes-fe && webdev build

fe-run: 
	echo "running frontend"
	cd quotes-fe && webdev serve

fe-all: fe-format fe-get fe-build fe-run


be-format:
	cd quotes-be && dartfmt -w -l 160 --fix .

be-get: 
	echo "getting backend dependencies" 
	cd quotes-be && pub get 
	
be-run: 
	echo "running frontend"
	cd quotes-be && dart bin/run_app.dart infra/local.json

be-all: be-format be-get be-run
