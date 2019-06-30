FROM debian:testing-slim

ADD . /quotes-be/
WORKDIR /quotes-be


RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install apt-transport-https -y
RUN apt-get install gnupg2 -y
RUN apt-get install git -y

RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'

RUN apt-get update
RUN apt-get install dart -y

ENV PATH "$PATH:$HOME/.pub-cache/bin"
ENV PATH "$PATH:/usr/lib/dart/bin"

RUN pub global activate webdev

RUN dart --version
RUN pub --version

ENV PATH "$PATH:$HOME/.pub-cache/bin"
ENV PATH "$PATH:/usr/lib/dart/bin"

RUN pwd
RUN ls -al

RUN pub get

EXPOSE 5050
CMD ["dart", "./cmd/run_app.dart", "./infra/docker.json"]


