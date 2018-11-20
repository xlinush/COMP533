from collections import namedtuple

import pandas as pd

genre_columns = ["movieId", "type"]
Genre = namedtuple("Genre", genre_columns)


def clean_genre(tsv_movies):
    """
    :param tsv_movies:
    """
    rows = []
    for row in tsv_movies.itertuples():
        genres = row.genres.split(',')
        for type in genres:
            genre = Genre(movieId=row.tconst, type=type)
            rows.append(genre._asdict())

    return pd.DataFrame(rows, columns=genre_columns)
