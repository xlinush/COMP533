import os
import sys
import pandas as pd

# configs
data_dir = ""
output_dir = "output"
file_movies = "title.basics.tsv"
file_akas = "title.akas.tsv"
file_principals = "title.principals.tsv"
file_ratings = "title.ratings.tsv"
file_names = "name.basics.tsv"


def sample_movies(fraction):
    movies = pd.read_table(data_dir+"/"+file_movies, index_col='tconst')
    return movies.sample(frac=float(fraction))


def sample_akas(movie_ids):
    akas = pd.read_table(data_dir+"/"+file_akas)
    rows = []
    for row in akas.itertuples():
        if row.titleId in movie_ids:
            rows.append(row._asdict())
    new_akas = pd.DataFrame(rows, columns=akas.columns)
    return new_akas


def sample_principals(movie_ids):
    principals = pd.read_table(data_dir+"/"+file_principals)
    rows = []
    for row in principals.itertuples():
        if row.tconst in movie_ids:
            rows.append(row._asdict())
    new_pricipals = pd.DataFrame(rows, columns=principals.columns)
    return new_pricipals


def sample_ratings(movie_ids):
    ratings = pd.read_table(data_dir+"/"+file_ratings)
    rows = []
    for row in ratings.itertuples():
        if row.tconst in movie_ids:
            rows.append(row._asdict())
    new_ratings = pd.DataFrame(rows, columns=ratings.columns)
    return new_ratings


def sample_names(movie_ids):
    names = pd.read_table(data_dir+"/"+file_names)
    rows = []
    for row in names.itertuples():
        titles = row.knownForTitles.split(",")
        for title in titles:
            if title in movie_ids:
                rows.append(row._asdict())
                break
    new_names = pd.DataFrame(rows, columns=names.columns)
    return new_names


if __name__ == "__main__":
    data_dir = sys.argv[1]
    fraction = sys.argv[2]

    # Write out movies
    movies = sample_movies(fraction)

    # Make dict
    movie_ids = movies.to_dict(orient='index')

    akas = sample_akas(movie_ids)
    principals = sample_principals(movie_ids)
    ratings = sample_ratings(movie_ids)
    names = sample_names(movie_ids)

    os.mkdir(output_dir)
    movies.to_csv(output_dir + "/" + file_movies, sep="\t", index=False)
    akas.to_csv(output_dir + "/" + file_akas, sep="\t", index=False)
    principals.to_csv(output_dir + "/" + file_principals, sep="\t", index=False)
    ratings.to_csv(output_dir + "/" + file_ratings, sep="\t", index=False)
    names.to_csv(output_dir + "/" + file_names, sep="\t", index=False)
