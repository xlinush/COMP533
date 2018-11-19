CREATE TABLE Movie (
  movieId CHAR(9),
  title VARCHAR(100) NOT NULL,
  releaseYear INTEGER NOT NULL,
  isAdult BOOLEAN DEFAULT FALSE,
  runtimeMinutes INTEGER,
  rating numeric(5, 2),
  numVotes INTEGER,
  PRIMARY KEY (movieId)
);

CREATE TABLE Alias (
  movieId CHAR(9),
  title VARCHAR(1000) NOT NULL,  -- some title can be over 500 chars eg. tt0053190
  isOriginal BOOLEAN DEFAULT FALSE,
  region VARCHAR(50),
  lang CHAR(3),
  PRIMARY KEY (movieId, title, isOriginal, region, lang),
  FOREIGN KEY (movieId) REFERENCES Movie(movieId)
);

CREATE TABLE Genre (
  movieId CHAR(9),
  type VARCHAR(50) NOT NULL,
  PRIMARY KEY (movieId, type)
);

CREATE TABLE Person (
  personId CHAR(9),
  name VARCHAR(100) NOT NULL,
  birthYear INTEGER,
  deathYear INTEGER,
  age INTEGER,
  PRIMARY KEY (personId)
);

CREATE TABLE Role (
  roleId CHAR(9),
  type VARCHAR(50) NOT NULL,
  PRIMARY KEY (roleId)
);

CREATE TABLE Assign (
  movieId CHAR(9),
  personId CHAR(9),
  roleId CHAR(9),
  PRIMARY KEY (movieId, personId, roleId),
  FOREIGN KEY (movieId) REFERENCES Movie(movieId),
  FOREIGN KEY (personId) REFERENCES Person(personId),
  FOREIGN KEY (roleId) REFERENCES Role(roleId)
);
