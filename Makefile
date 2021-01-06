

docker:
	sudo systemctl start docker

compose-build:
	sudo docker-compose build

compose-up:
	sudo docker-compose up

deps:
	echo "starting elasticsearch image (version 6.4.1)"
	docker run -d -p 9200:9200 -p 9300:9300 -e \"discovery.type=single-node\" elasticsearch:6.4.1

fe-format:
	cd quotes-fe && dartfmt -w -l 160 --fix .

fe-get:
	echo "getting frontend dependencies" 
	cd quotes-fe && pub upgrade && pub get 

fe-build:
	echo "building frontend"
	#cd quotes-fe && pub run build_runner clean
	rm quotes-fe/lib/generated_consts.dart ||:
	cd quotes-fe && webdev build # --delete-conflicting-outputs

fe-run: 
	echo "running frontend"
	cd quotes-fe && webdev serve

fe-all: fe-format fe-get fe-build be-test fe-run


be-format:
	cd quotes-be && dartfmt -w -l 160 --fix .

be-get: 
	echo "getting backend dependencies" 
	cd quotes-be && pub upgrade && pub get 
	
be-test:
	echo "running backend tests" 
	cd quotes-be && dart pub run test ./..

be-run: 
	echo "running backend"
	cd quotes-be && dart bin/run_app.dart infra/local.json

be-init:
	echo "Init db"
	./quotes-be/infra/init.sh
	


be-all: be-format be-get be-run
