from collections import namedtuple

import pandas as pd

alias_columns = ["movieId", "title", "isOriginal", "region", "lang"]
Alias = namedtuple("Alias", alias_columns)


def clean_alias(tsv_akas):
    """
    :param tsv_akas:
    """
    rows = []
    for row in tsv_akas.itertuples():
        # 1. Row level cleaning

        # skip informal titles, which affect data integrity when
        # inserted into the alias table
        if "informal" in row.attributes:
            continue

        # skip non-original rows without specified regions
        if "\\N" == row.region:
            continue

        # skip rows where region starts with "X"
        if str(row.region).startswith("X"):
            continue

        # 2. Column level cleaning

        # isOriginal: transform 1/0 to True/False
        # region: replace \N with OG for original rows
        if row.isOriginalTitle == 1 or row.isOriginalTitle == '1':
            is_original_title = True
            region = "OG"
        else:
            is_original_title = False
            region = row.region

        # lang: set to "NOL" if not specified
        language = "NOL" if row.language == "\\N" else row.language

        alias = Alias(movieId=row.titleId,
                      title=row.title,
                      isOriginal=is_original_title,
                      region=region,
                      lang=language)
        rows.append(alias._asdict())

    return pd.DataFrame(rows, columns=alias_columns)
