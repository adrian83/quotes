FROM ubuntu:21.10

ADD . /quotesfe2/
WORKDIR /quotesfe2

RUN apt-get update -y

RUN apt-get install wget xz-utils git python3 -y

RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.0-stable.tar.xz

RUN ls -al

RUN tar xf ./flutter_linux_2.10.0-stable.tar.xz

RUN ls -al

RUN pwd

ENV PATH="/quotesfe2/flutter/bin:${PATH}"

RUN echo $PATH

RUN flutter doctor

RUN flutter config --enable-web

RUN flutter build web


RUN cd build/web/

EXPOSE 8000

CMD ["/usr/bin/python3", "-m", "http.server"]