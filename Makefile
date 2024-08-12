
docker:
	sudo systemctl start docker

compose:
	sudo docker-compose up --build


deps:
	echo "starting elasticsearch image (version 7.12.0)"
	docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.12.0


fe-format:
	cd quotes_frontend && dart format -o write -l 180 --fix . && dart fix -n . && dart analyze

fe-build:
	echo "building frontend"
	cd quotes_frontend && flutter config --enable-web && flutter build web

fe-run: export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

fe-run: 
	echo "running frontend"
	cd quotes_frontend && flutter run -d chrome --dart-define ENV=local

fe-all: fe-format fe-build fe-run


be-run:
	echo "running backend"
	dart quotes_backend/bin/main.dart 

be-format:
	cd quotes_common && dart format -o write -l 180 --fix . && dart fix -n . && dart analyze
	cd quotes_backend && dart format -o write -l 180 --fix . && dart fix -n . && dart analyze

be-get: 
	echo "getting backend dependencies" 
	cd quotes_backend && dart pub upgrade && dart pub get 
	
be-test:
	echo "running backend tests" 
	cd quotes_backend && dart run build_runner build && dart test . --coverage=. --reporter=expanded

be-init:
	echo "Init db"
	./quotes_backend/init.sh

be-all: be-format be-get be-test be-run
