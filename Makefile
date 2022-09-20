
docker:
	sudo systemctl start docker

compose-build:
	sudo docker-compose build

compose-up:
	sudo docker-compose up


deps:
	echo "starting elasticsearch image (version 7.12.0)"
	docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.12.0


fe-format:
	cd quotes-fe && dart format -o write -l 120 --fix . #&& dart fix -n . && dart analyze

fe-get:
	echo "getting frontend dependencies" 
	cd quotes-fe && dart pub upgrade && dart pub get  

fe-build:
	echo "building frontend"
	#cd quotes-fe && dart pub run build_runner clean
	rm quotes-fe/lib/generated_consts.dart ||:
	cd quotes-fe && webdev build # --delete-conflicting-outputs

fe-run: 
	echo "running frontend"
	cd quotes-fe && webdev serve

fe-all: fe-format fe-get fe-build fe-run

be-run:
	echo "running backend V2"
	dart quotesbe2/bin/main.dart 

#be-format:
#	cd quotesbe2 && dart format -o write -l 120 --fix . && dart fix -n . && dart analyze

be-get: 
	echo "getting backend dependencies" 
	cd quotesbe2 && dart pub upgrade && dart pub get 
	
be-test:
	echo "running backend tests" 

	cd quotesbe2 && dart pub run build_runner build && dart test . --coverage=. --reporter=expanded
#./.. --coverage=./..

be-init:
	echo "Init db"
	./quotesbe2/init.sh

#be-all: be-format be-get be-test be-run
be-all: be-get be-test be-run
