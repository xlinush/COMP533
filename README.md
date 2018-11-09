# COMP533 Final Project

## Dev Info

**Data Preparation**

https://datasets.imdbws.com/

First put the downloaded data with .tsv suffixes into a directory such as *./data*.

**Code organization**

    ./python # python files for data sampling and cleaning
    ./sql # sql files for relation definitions and analysis

## Data Sample

    python ./python/subsample.py [data_dir] [sample_ratio]

## Data Clean

    python ./python/clean.py [sample_data_dir]
   
