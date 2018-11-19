from collections import namedtuple
import pandas as pd

assign_columns = ["movieId", "personId", "roleId"]
Assign = namedtuple("Assign", ["movieId", "personId", "roleId"])

def clean_assign(tsv_principals, tsv_role):
    """
    :param tsv_principals
    :param tsv_role
    """
    rows = []
    types = np.array(tsv_role['type'])
    role_dict = {}
    num = 1
    for type in types:
        role_dict[type] = num
        num += 1
    for row in tsv_principals.itertuples():
        roleId = role_dict[row.category]      
        assign = Assign(movieId = row.tconst,
                       personId = row.nconst,
                       roleId = roleId)
        rows.append(assign._asdict())
    return pd.DataFrame(rows, columns=assign_columns)
