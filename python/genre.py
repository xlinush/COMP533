from collections import namedtuple
import pandas as pd
import numpy as np

genre_columns = ["genreId", "genre"]
Genre = namedtuple("Genre", ["genreId", "genre"])

def clean_genre(tsv_movies):
    """
    :param tsv_movies:
    """
    rows = []
    genres = []
    for couple in np.array(tsv_movies['genres']):
        for genre in couple.split(','):
            genres.append(genre)
    genres = set(genres)
    num = 0
    for genre in genres:
        if genre == r'\N':
            continue
        num += 1
        genreId = 'g' + str(num)
        genre = Genre(genreId=genreId,
                      genre=genre)
        rows.append(genre._asdict())
    return pd.DataFrame(rows, columns=genre_columns)


