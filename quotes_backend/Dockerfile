FROM dart:3.3


COPY ./quotes_common /quotes_common
WORKDIR /quotes_common
RUN dart pub get

COPY ./quotes_backend /quotes_backend
WORKDIR /quotes_backend
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Start server.
EXPOSE 5050
CMD ["bin/server"]