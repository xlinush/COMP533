/*
 * 1. Find most popular genres throughout decades.
 */

/*
 * Firstly, pick top 15 meaningful genres which are
 * 1.  Drama
 * 2.  Comedy
 * 3.  Documentary
 * 4.  Romance
 * 5.  Animation
 * 6.  Crime
 * 7.  Music
 * 8.  Action
 * 9.  Sport
 * 10. Fantasy
 * 11. Horror
 * 12. Thriller
 * 13. Sci-Fi
 * 14. History
 * 15. Biography
 */
select type, count(type) num
from genre
group by type
order by num desc;

/* Create a temp table to store num of movies from different genres */
create table top15genres (
  timeSpan    varchar(20),
  drama       integer default 0,
  comedy      integer default 0,
  documentary integer default 0,
  romance     integer default 0,
  animation   integer default 0,
  crime       integer default 0,
  music       integer default 0,
  action      integer default 0,
  sport       integer default 0,
  fantasy     integer default 0,
  horror      integer default 0,
  thriller    integer default 0,
  sci_fi      integer default 0,
  history     integer default 0,
  biography   integer default 0,
  primary key (timeSpan)
);

/*
 * Insert into top15genres by different decades, starting from 1901 to 2018
 * timespan is determined by yearInterval, eg. 10, then timespans are
 * 1901 ~ 1910 / ... / 1901 + ((n - 1) * yearInterval) ~ 1901 + (n * yearInterval - 1)
 */
create or replace function fillTop15Genres(yearInterval integer)
returns void as
$$
declare
  movieCursor   refcursor;
  movieRecord   record;
  selectQuery   text;
  updateQuery   text;
  currentYear   integer;
  currentPeriod varchar(20) default '';
  movieType     varchar;
begin
  selectQuery = 'select * from movie as m, genre as g
                 where m.movieId = g.movieId
                 order by m.releaseyear asc';
  open movieCursor for execute selectQuery;
  loop
    fetch movieCursor into movieRecord;
    exit when not found;

    currentYear = movieRecord.releaseyear;

    /* skip unwanded time spans and genres */
    if (currentYear is null
        or (currentYear < 1901)
        or (currentYear > 2018)
        or (select movieRecord.type not ilike all (
          select column_name from information_schema.columns where table_name = 'top15genres'
        ))) then
      continue;
    end if;
    if (currentYear < 2020 - yearInterval) then
      currentPeriod = quote_literal(currentYear - currentYear % yearInterval + 1)
                      || ' ~ ' ||
                      quote_literal(currentYear - currentYear % yearInterval + yearInterval);
    else
      currentPeriod = quote_literal(2020 - yearInterval + 1) || ' ~ present';
    end if;
    movieType = movieRecord.type;
    updateQuery = 'insert into top15genres (timespan, '
                  || movieType
                  || ') values ($1, 1) on conflict(timespan) do update set '
                  || movieType
                  || ' = top15genres.'
                  || movieType
                  || ' + 1';
    if (updateQuery is not null) then
      execute updateQuery using currentPeriod;
    else
      raise notice 'rawType = %, currentPeriod = %', movieRecord.type, currentPeriod;
    end if;
  end loop;

end;
$$
language plpgsql;

/* Test Cases

select fillTop15Genres(10);
select * from top15genres;

select fillTop15Genres(20);
select * from top15genres;

*/
