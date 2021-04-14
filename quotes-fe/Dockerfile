FROM google/dart:2.12

ADD . /quotes-fe/
WORKDIR /quotes-fe

RUN dart --version
RUN dart pub get
RUN dart pub global activate webdev
RUN dart pub run build_runner build --delete-conflicting-outputs

EXPOSE 8080
CMD ["/root/.pub-cache/bin/webdev", "serve", "--hostname", "0.0.0.0", "--release"]
