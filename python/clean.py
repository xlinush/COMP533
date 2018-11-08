import sys
from collections import namedtuple
import pandas as pd

from movie import clean_movie
from alias import clean_alias
from genre import clean_genre
from person import clean_person
from role import clean_role
from assign import clean_assign

# configs
data_dir = ""
output_dir = "relations"
file_movies = "title.basics.tsv"
file_akas = "title.akas.tsv"
file_principals = "title.principals.tsv"
file_ratings = "title.ratings.tsv"
file_names = "name.basics.tsv"

file_relation_movie = "movie.tsv"
file_relation_alias = "alias.tsv"
file_relation_genre = "genre.tsv"
file_relation_person = "person.tsv"
file_relation_role = "role.tsv"
file_relation_assign = "assign.tsv"

# table definition
Movie = namedtuple("Movie", ["movieId", "title", "releaseYear", "isAdult", "runtimeMinutes", "rating", "numVotes"])
Alias = namedtuple("Alias", ["movieId", "title", "isOriginal", "region"])
Genre = namedtuple("Genre", ["movieId", "type"])
Person = namedtuple("Person", ["personId", "name", "birthYear", "deathYear", "age"])
Role = namedtuple("Role", ["roleId", "type"])
Assign = namedtuple("Assign", ["movieId", "personId", "roleId"])


if __name__ == "__main__":
    data_dir = sys.argv[1]

    tsv_movies = pd.read_table(data_dir+"/"+file_movies, index_col='tconst')
    tsv_akas = pd.read_table(data_dir+"/"+file_akas, index_col='titleId')
    tsv_principals = pd.read_table(data_dir+"/"+file_principals, index_col='tconst')
    tsv_ratings = pd.read_table(data_dir+"/"+file_ratings, index_col='tconst')
    tsv_names = pd.read_table(data_dir+"/"+file_names, index_col='nconst')

    relation_movie = clean_movie()
    relation_alias = clean_alias()
    relation_genre = clean_genre()
    relation_person = clean_person()
    relation_role = clean_role()
    relation_assign = clean_assign()

    os.mkdir(output_dir)
    relation_movie.to_csv(output_dir + "/" + file_relation_movie, sep="\t", index=True)
    relation_alias.to_csv(output_dir + "/" + file_relation_alias, sep="\t", index=True)
    relation_genre.to_csv(output_dir + "/" + file_relation_genre, sep="\t", index=True)
    relation_person.to_csv(output_dir + "/" + file_relation_person, sep="\t", index=True)
    relation_role.to_csv(output_dir + "/" + file_relation_role, sep="\t", index=True)
    relation_assign.to_csv(output_dir + "/" + file_relation_assign, sep="\t", index=True)
