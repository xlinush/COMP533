import os
import sys
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


if __name__ == "__main__":
    data_dir = sys.argv[1]

    tsv_movies = pd.read_table(data_dir+"/"+file_movies)
    tsv_akas = pd.read_table(data_dir+"/"+file_akas)
    tsv_principals = pd.read_table(data_dir+"/"+file_principals)
    tsv_ratings = pd.read_table(data_dir+"/"+file_ratings)
    tsv_names = pd.read_table(data_dir+"/"+file_names)

    relation_movie = clean_movie(tsv_movies, tsv_ratings)
    relation_alias = clean_alias(tsv_akas)
    relation_genre = clean_genre(tsv_movies)
    relation_person = clean_person(tsv_names)
    relation_role = clean_role(tsv_principals, tsv_names)
    relation_assign = clean_assign(tsv_principals, relation_role)

    os.mkdir(output_dir)
    if relation_movie is not None:
        relation_movie.to_csv(output_dir + "/" + file_relation_movie, sep="\t", index=False, header=False)
    if relation_alias is not None:
        relation_alias.to_csv(output_dir + "/" + file_relation_alias, sep="\t", index=False, header=False)
    if relation_genre is not None:
        relation_genre.to_csv(output_dir + "/" + file_relation_genre, sep="\t", index=False, header=False)
    if relation_person is not None:
        relation_person.to_csv(output_dir + "/" + file_relation_person, sep="\t", index=False, header=False)
    if relation_role is not None:
        relation_role.to_csv(output_dir + "/" + file_relation_role, sep="\t", index=False, header=False)
    if relation_assign is not None:
        relation_assign.to_csv(output_dir + "/" + file_relation_assign, sep="\t", index=False, header=False)
