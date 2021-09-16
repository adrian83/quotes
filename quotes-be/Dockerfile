FROM google/dart:2.13.4

ADD . /quotes-be/
WORKDIR /quotes-be

RUN dart --version
RUN dart pub get

EXPOSE 5050

CMD ["bash", "start.sh"]