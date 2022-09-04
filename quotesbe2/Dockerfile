FROM dart:2.17

ADD . /quotesbe2/
WORKDIR /quotesbe2

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server


# Start server.
EXPOSE 5050
CMD ["bin/server"]