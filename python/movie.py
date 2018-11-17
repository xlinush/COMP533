from collections import namedtuple
import pandas as pd

movie_columns = ["movieId", "title", "startYear", "isAdult", "runtimeMinutes", "rating", "numVotes"]
Movie = namedtuple("Movie", movie_columns)


def clean_movie(tsv_movies, tsv_ratings):
    """
    :param tsv_movies:
    :param tsv_ratings:
    :return:
    """
    ratings = tsv_ratings.set_index("tconst").to_dict(orient='index')
    rows = []
    for row in tsv_movies.itertuples():
        rating = 0.0
        num_votes = 0
        if row.tconst in ratings:
            rating = ratings[row.tconst]['averageRating']
            num_votes = ratings[row.tconst]['numVotes']
        movie = Movie(movieId=row.tconst,
                      title=row.primaryTitle,
                      startYear=row.startYear,
                      isAdult=row.isAdult,
                      runtimeMinutes=row.runtimeMinutes,
                      rating=rating,
                      numVotes=num_votes)
        rows.append(movie._asdict())
    return pd.DataFrame(rows, columns=movie_columns)
