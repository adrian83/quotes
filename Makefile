

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

be-format:
	cd quotes-be && dartfmt -w -l 160 --fix .

fe-get: fe-format
	echo "getting frontend dependencies" 
	cd quotes-fe && pub get 

be-get: be-format
	echo "getting backend dependencies" 
	cd quotes-be && pub get 

fe-build: fe-get 
	echo "building frontend"
	cd quotes-fe && webdev build

fe-run: fe-build
	echo "running frontend"
	cd quotes-fe && webdev serve

be-run: be-get
	echo "running frontend"
	cd quotes-be && dart bin/run_app.dart infra/local.json
