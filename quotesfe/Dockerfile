FROM ubuntu:24.04




ENV FLUTTER_VER=3.19.2-stable

RUN apt-get update -y
RUN apt-get install wget xz-utils git python3 -y

RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VER.tar.xz

RUN tar xf ./flutter_linux_$FLUTTER_VER.tar.xz

RUN git config --global --add safe.directory '*'

ENV PATH="/flutter/bin:${PATH}"


COPY ./quotes_common /quotes_common
WORKDIR /quotes_common
RUN dart pub get

COPY ./quotesfe /quotesfe
WORKDIR /quotesfe
RUN dart pub get
RUN flutter doctor
RUN flutter config --enable-web
RUN flutter build web --dart-define ENV=compose

EXPOSE 8000

CMD ["/usr/bin/python3", "-m", "http.server", "8000", "--directory", "/quotesfe/build/web"]