from collections import namedtuple

Alias = namedtuple("Assign", ["movieId", "personId", "roleId"])


def clean_assign(tsv_principals, relation_role):
    """
    :param tsv_principals: ["tconst", "ordering", "nconst", "category", "job", "characters"], use the category field to match roles
    :param relation_role: namedtuple("Role", ["roleId", "type"])
    """
    pass
