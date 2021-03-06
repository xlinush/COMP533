import os
import sys
import pandas as pd

# configs
data_dir = ""
output_dir = "samples"
file_movies = "title.basics.tsv"
file_akas = "title.akas.tsv"
file_principals = "title.principals.tsv"
file_ratings = "title.ratings.tsv"
file_names = "name.basics.tsv"


def sample_movies(fraction):
    movies = pd.read_table(data_dir+"/"+file_movies)
    movies = movies.query('titleType == "movie" or titleType == "short" or \
                           titleType == "video" or titleType == "videoGame"')
    return movies.sample(frac=float(fraction))


def sample_names(name_ids):
    names = pd.read_table(data_dir+"/"+file_names)
    rows = []
    for row in names.itertuples():
        if row.nconst in name_ids:
            rows.append(row._asdict())
    new_names = pd.DataFrame(rows, columns=names.columns)
    return new_names


def sample_akas(movie_ids):
    akas = pd.read_table(data_dir+"/"+file_akas)
    rows = []
    for row in akas.itertuples():
        if row.titleId in movie_ids:
            rows.append(row._asdict())
    new_akas = pd.DataFrame(rows, columns=akas.columns)
    return new_akas


def sample_principals(movie_ids, name_ids):
    principals = pd.read_table(data_dir+"/"+file_principals)
    rows = []
    for row in principals.itertuples():
        if row.tconst in movie_ids:
            if row.nconst in name_ids:
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


if __name__ == "__main__":
    data_dir = sys.argv[1]
    fraction = sys.argv[2]

    # Get movie ids
    movies = sample_movies(fraction)
    movie_ids = movies.set_index("tconst").to_dict(orient="index")

    # Get name ids for all movies
    name_ids = pd.read_table(data_dir+"/"+file_names).set_index("nconst").to_dict(orient="index")
    principals = sample_principals(movie_ids, name_ids)

    # Get name ids for all principals
    name_ids = principals.set_index("nconst").to_dict(orient="index")

    names = sample_names(name_ids)
    akas = sample_akas(movie_ids)
    ratings = sample_ratings(movie_ids)

    os.mkdir(output_dir)
    movies.to_csv(output_dir + "/" + file_movies, sep="\t", index=False)
    names.to_csv(output_dir + "/" + file_names, sep="\t", index=False)
    akas.to_csv(output_dir + "/" + file_akas, sep="\t", index=False)
    principals.to_csv(output_dir + "/" + file_principals, sep="\t", index=False)
    ratings.to_csv(output_dir + "/" + file_ratings, sep="\t", index=False)
