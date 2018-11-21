CREATE TABLE Movie (
  movieId VARCHAR(10),
  title VARCHAR(1000) NOT NULL,
  releaseYear INTEGER,
  isAdult BOOLEAN DEFAULT FALSE,
  runtimeMinutes INTEGER,
  rating numeric(5, 2),
  numVotes INTEGER,
  PRIMARY KEY (movieId)
);

CREATE TABLE Alias (
  movieId CHAR(10),
  title VARCHAR(1000) NOT NULL,  -- some title can be over 500 chars eg. tt0053190
  isOriginal BOOLEAN DEFAULT FALSE,
  region VARCHAR(50),
  lang CHAR(3),
  PRIMARY KEY (movieId, title, isOriginal, region, lang),
  FOREIGN KEY (movieId) REFERENCES Movie(movieId)
);

CREATE TABLE Genre (
  movieId CHAR(10),
  type VARCHAR(50) NOT NULL,
  PRIMARY KEY (movieId, type)
);

CREATE TABLE Person (
  personId CHAR(10),
  name VARCHAR(100) NOT NULL,
  birthYear INTEGER,
  deathYear INTEGER,
  age INTEGER,
  PRIMARY KEY (personId)
);

CREATE TABLE Role (
  roleId CHAR(10),
  type VARCHAR(50) NOT NULL,
  PRIMARY KEY (roleId)
);

CREATE TABLE Assign (
  movieId CHAR(10),
  personId CHAR(10),
  roleId CHAR(10),
  PRIMARY KEY (movieId, personId, roleId),
  FOREIGN KEY (movieId) REFERENCES Movie(movieId),
  FOREIGN KEY (personId) REFERENCES Person(personId),
  FOREIGN KEY (roleId) REFERENCES Role(roleId)
);
