FROM dart:3.3

ADD . /quotesbe/
WORKDIR /quotesbe

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Start server.
EXPOSE 5050
CMD ["bin/server"]