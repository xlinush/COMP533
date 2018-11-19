from collections import namedtuple
import numpy as np

Person = namedtuple("Person", ["personId", "name", "birthYear", "deathYear", "age"])
person_columns = ["personId", "name", "birthYear", "deathYear", "age"]


def clean_person(tsv_names):
    """
    :param tsv_names: ["nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"]
    """
    rows = []
    clean_birthYear = np.array(tsv_principals['birthYear'])
    clean_deathYear = np.array(tsv_principals['deathYear'])
    for i in range(len(clean_birthYear)):
        if clean_deathYear[i] == r'\N':
            clean_deathYear[i] = ''
    for i in range(len(clean_deathYear)):
        if clean_deathYear[i] == r'\N':
            clean_deathYear[i] = ''
    tsv_principals['birthYear'] = clean_birthYear
    tsv_principals['deathYear'] = clean_deathYear
    
    for row in tsv_principals.itertuples():
        if row.birthYear == r'':
            age = ''
        if row.birthYear != r'' and row.deathYear == r'':
            age = 2018 - int(row.birthYear)
        if row.birthYear != r'' and row.deathYear != r'':  
            age = int(row.deathYear)- int(row.birthYear)
        person = Person(personId = row.nconst,
                        name = row.primaryName,
                        birthYear = row.birthYear,
                        deathYear = row.deathYear,
                        age = age)
        
        rows.append(person._asdict())
    return pd.DataFrame(rows, columns=person_columns)
