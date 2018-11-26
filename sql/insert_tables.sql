COPY movie
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/movie.tsv'
  WITH (DELIMITER E'\t', NULL '\N');

COPY genre
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/genre.tsv'
  WITH (DELIMITER E'\t', NULL '\N');

COPY alias
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/alias.tsv'
  WITH (DELIMITER E'\t', NULL '\N');

COPY role
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/role.tsv'
  WITH (DELIMITER E'\t', NULL '');

COPY person
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/person.tsv'
  WITH (DELIMITER E'\t', NULL '');

COPY assign
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/assign.tsv'
  WITH (DELIMITER E'\t', NULL '');

COPY recommend_movie
  FROM '/home/jokeren/Codes/COMP533/COMP533/relations/recommend_movie.tsv'
  WITH (DELIMITER E'\t', NULL '');