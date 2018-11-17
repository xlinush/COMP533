from collections import namedtuple

Person = namedtuple("Person", ["personId", "name", "birthYear", "deathYear", "age"])


def clean_person(tsv_names):
    """
    :param tsv_names: ["nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"]
    """
    pass
