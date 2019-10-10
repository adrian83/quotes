FROM debian:testing-slim

ADD . /quotes-fe/
WORKDIR /quotes-fe


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

RUN ls $HOME/.pub-cache/bin

ENV PATH "$PATH:$HOME/.pub-cache/bin"
ENV PATH "$PATH:/usr/lib/dart/bin"


RUN dart --version
RUN pub --version
RUN $HOME/.pub-cache/bin/webdev --version
RUN pwd

RUN cd $HOME/.pub-cache/bin/ && pwd


RUN pub get
RUN pub run build_runner build --delete-conflicting-outputs

EXPOSE 8080
CMD ["/root/.pub-cache/bin/webdev", "serve", "--hostname", "0.0.0.0"]


