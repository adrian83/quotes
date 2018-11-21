
CREATE TABLE Author(
   ID           CHAR(100) PRIMARY KEY   NOT NULL,
   NAME         CHAR(200)               NOT NULL,
   DESCRIPTION  CHAR(200)               NOT NULL,
   CREATED_UTC  TIMESTAMP               NOT NULL
);
