
CREATE TABLE Author (
   ID           CHAR(100) PRIMARY KEY   NOT NULL,
   NAME         CHAR(200)               NOT NULL,
   DESCRIPTION  CHAR(200)               NOT NULL,
   CREATED_UTC  TIMESTAMP               NOT NULL
);

CREATE TABLE Book (
   ID           CHAR(100) PRIMARY KEY   NOT NULL,
   TITLE        CHAR(200)               NOT NULL,
   DESCRIPTION  CHAR(200)               NOT NULL,
   AUTHOR_ID    CHAR(100)               NOT NULL,
   CREATED_UTC  TIMESTAMP               NOT NULL
);

CREATE TABLE Quote (
   ID           CHAR(100) PRIMARY KEY   NOT NULL,
   TEXT         CHAR(200)               NOT NULL,
   AUTHOR_ID    CHAR(100)               NOT NULL,
   BOOK_ID      CHAR(100)               NOT NULL,
   CREATED_UTC  TIMESTAMP               NOT NULL
);
