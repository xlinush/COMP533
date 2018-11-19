from collections import namedtuple
import panadas as pd

role_columns = ["roleId", "type"]
Role = namedtuple("Role", role_columns)


def clean_role(tsv_principals, tsv_names):
    """
    :param tsv_principals: ["tconst", "ordering", "nconst", "category", "job", "characters"]
    :param tsv_names: ["nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"]
    :
    : Use tsv_names to get primary roles of a person, and union the results
    : with categories in tsv_principals to generate all the roles of the person
    """
    rows = []
    num = 1
    distinct = tsv_principals['category'].drop_duplicates()
    for row in distinct:
        roleId = 'r'+str(num)
        role = Role(roleId = roleId,
                    type = row)
        rows.append(role._asdict())
        num += 1    
    return pd.DataFrame(rows, columns=role_columns)
