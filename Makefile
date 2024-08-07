
docker:
	sudo systemctl start docker

compose-up:
	sudo docker-compose up --build


deps:
	echo "starting elasticsearch image (version 7.12.0)"
	docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.12.0


fe-format:
	cd quotesfe && dart format -o write -l 180 --fix . && dart fix -n . && dart analyze

fe-build:
	echo "building frontend"
	cd quotesfe && flutter config --enable-web && flutter build web

fe-run: export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

fe-run: 
	echo "running frontend"
	cd quotesfe && flutter run -d chrome --dart-define ENV=local

fe-all: fe-format fe-build fe-run


be-run:
	echo "running backend"
	dart quotesbe/bin/main.dart 

be-format:
	cd quotesbe && dart format -o write -l 180 --fix . && dart fix -n . && dart analyze

be-get: 
	echo "getting backend dependencies" 
	cd quotesbe && dart pub upgrade && dart pub get 
	
be-test:
	echo "running backend tests" 
	cd quotesbe && dart run build_runner build && dart test . --coverage=. --reporter=expanded

be-init:
	echo "Init db"
	./quotesbe/init.sh

be-all: be-format be-get be-test be-run
