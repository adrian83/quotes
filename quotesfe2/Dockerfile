FROM ubuntu:22.04

ADD . /quotesfe2/
WORKDIR /quotesfe2

RUN apt-get update -y
RUN apt-get install wget xz-utils git python3 -y

RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.5-stable.tar.xz
RUN tar xf ./flutter_linux_3.0.5-stable.tar.xz

ENV PATH="/quotesfe2/flutter/bin:${PATH}"

RUN flutter doctor
RUN flutter config --enable-web
RUN flutter build web

EXPOSE 8000

CMD ["/usr/bin/python3", "-m", "http.server", "8000", "--directory", "/quotesfe2/build/web"]