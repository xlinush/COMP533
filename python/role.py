from collections import namedtuple

Role = namedtuple("Role", ["roleId", "type"])


def clean_role(tsv_principals, tsv_names):
    """
    :param tsv_principals: ["tconst", "ordering", "nconst", "category", "job", "characters"]
    :param tsv_names: ["nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"]
    :
    : Use tsv_names to get primary roles of a person, and union the results
    : with categories in tsv_principals to generate all the roles of the person
    """
    pass
