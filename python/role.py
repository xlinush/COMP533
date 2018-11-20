from collections import namedtuple
import pandas as pd
import numpy as np

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
    professions = []
    
    for couple in np.array(tsv_names['primaryProfession']):
        for profession in str(couple).split(','):
            professions.append(profession)
           
    distinct = tsv_principals['category'].drop_duplicates()
    
    for role in distinct:
        professions.append(role)
    
    professions = set(professions)
    
    for row in professions:
        roleId = num
        role = Role(roleId = roleId,
                    type = row)
        rows.append(role._asdict())
        num += 1    
    return pd.DataFrame(rows, columns=role_columns)
