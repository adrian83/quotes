FROM google/dart:2.5

ADD . /quotes-be/
WORKDIR /quotes-be

RUN dart --version
RUN pub --version

RUN pub get

RUN pub global activate webdev

EXPOSE 5050

CMD ["dart", "./bin/run_app.dart", "./infra/docker.json", "populate"]
