FROM google/dart:2.12



ADD . /quotes-be/
WORKDIR /quotes-be

#RUN dart pub run test ./..

RUN dart --version
RUN pub --version

RUN pub get

RUN pub global activate webdev

EXPOSE 5050

CMD ["bash", "start.sh"]