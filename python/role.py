from collections import namedtuple

role_columns = ["roleId", "type"]
Role = namedtuple("Role", ["roleId", "type"])

def clean_role(tsv_principals):
    """
    :param tsv_principals:
    """
    rows = []
    num = 1
    distinct = tsv_principals['category'].drop_duplicates()
    for row in distinct:
        roleId = 'r'+str(num)
        role = Role(roleId = roleId,
                    type = row)
        
        rows.append(role._asdict())
        num +=1    
    return pd.DataFrame(rows, columns=role_columns)
