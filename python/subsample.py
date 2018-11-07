import sys
import pandas as pd

# configs
data_dir = ""
file_movies = "title.basics.tsv"
file_akas = "title.akas.tsv"
file_principals = "title.principals.tsv"
file_ratings = "title.ratings.tsv"
file_names = "name.basics.tsv"


def sample_movies(fraction):
    movies = pd.read_table(data_dir+"/"+file_movies)
    return movies.sample(frac=float(fraction))


def sample_akas(movies):
    pass


def sample_principals(movies):
    pass


def sample_ratings(movies):
    pass


def sample_names(movies):
    pass


if __name__ == "__main__":
    data_dir = sys.argv[1]
    fraction = sys.argv[2]
    movies = sample_movies(fraction)
    akas = sample_akas(movies)
    principals = sample_principals(movies)
    ratings = sample_ratings(movies)
    names = sample_names(movies)
    movies.to_csv(file_movies, sep="\t", index=False)
