import 'dart:io';

var contentTypes = {
  "html": new ContentType("text", "html", charset: "utf-8"),
  "css": new ContentType("text", "css", charset: "utf-8")
};

main() {
  HttpServer.bind(InternetAddress.ANY_IP_V6, 8080).then((server) {
    server.listen((HttpRequest request) {
      try {
        String filePath = request.uri.path;
        if (filePath == "/") {
          filePath = "/index.html";
        }

        if (filePath == "/favicon.ico") {
          filePath = "/favicon.png";
        }

        print(filePath);
        final File file = new File("./build$filePath");

        var parts = filePath.split(".");
        var extension = parts[parts.length - 1];
        var contentType = contentTypes[extension];
        if (contentType != null) {
          request.response.headers.contentType = contentType;
        }

        file.openRead().pipe(request.response);
      } on FileSystemException {
        request.response.statusCode = HttpStatus.notFound;
        request.response.close();
      } on Exception {
        request.response.statusCode = HttpStatus.notFound;
        request.response.close();
      }
    });
  });
}
