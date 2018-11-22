CREATE OR REPLACE FUNCTION multiScaleRanking(rankingType VARCHAR(10), genreType VARCHAR(50), roleType VARCHAR(50), region VARCHAR(50)) RETURNS
TABLE (id CHAR(10), name VARCHAR(1000), rating numeric) AS $$
DECLARE
	queryString TEXT;
BEGIN
	queryString = 'DROP VIEW IF EXISTS v; CREATE VIEW v AS ';
	IF rankingType = 'person' THEN
		queryString = queryString ||
                              'SELECT p.personid AS id, p.name AS name, p.rating AS rating FROM (
                               SELECT p.personid, p.name, ROUND(AVG(m.rating), 3) AS rating
                               FROM person AS p, assign AS a, movie AS m ';
		IF genreType <> '' THEN
			queryString = queryString || ', genre AS g ';
		END IF;
		IF roleType <> '' THEN
			queryString = queryString || ', role AS r ';
		END IF;
		IF region <> '' THEN
			queryString = queryString || ', alias AS al ';
		END IF;
		queryString = queryString || 'WHERE p.personid = a.personid AND m.movieid = a.movieid ';
		IF genreType <> '' THEN
			queryString = queryString || 'AND g.movieid = a.movieid AND g.type = ' || QUOTE_LITERAL(genreType) || ' ';
		END IF;
		IF roleType <> '' THEN
			queryString = queryString || 'AND r.roleid = a.roleid AND r.type = ' || QUOTE_LITERAL(roleType) || ' ';
		END IF;
		IF region <> '' THEN
			queryString = queryString || 'AND al.movieid = a.movieid AND al.region = ' || QUOTE_LITERAL(region) || ' ';
		END IF;
		queryString = queryString || 'GROUP BY p.personid) AS p ORDER BY p.rating DESC;';
	ELSIF rankingType = 'movie' THEN
		queryString = queryString ||
                              'SELECT m.movieid AS id, m.title AS name, ROUND(m.rating, 3) AS rating
                               FROM movie AS m, assign AS a ';
		IF genreType <> '' THEN
			queryString = queryString || ', genre AS g ';
		END IF;
		IF region <> '' THEN
			queryString = queryString || ', alias AS al ';
		END IF;
		queryString = queryString || 'WHERE m.movieid = a.movieid ';
		IF genreType <> '' THEN
			queryString = queryString || 'AND g.movieid = a.movieid AND g.type = ' || QUOTE_LITERAL(genreType) || ' ';
		END IF;
		IF region <> '' THEN
			queryString = queryString || 'AND al.movieid = a.movieid AND al.region = ' || QUOTE_LITERAL(region) || ' ';
		END IF;
		queryString = queryString || 'ORDER BY m.rating DESC;';
	ELSE
		RAISE EXCEPTION 'Unsupported rankingType-->%', rankingType;
	END IF;
    EXECUTE queryString;
	RETURN QUERY SELECT v.id, v.name, v.rating FROM v;
END;
$$ LANGUAGE plpgsql;

/* Test Cases																											 

SELECT * FROM multiScaleRanking('person', 'Short', 'director', 'US');										 
SELECT * FROM multiScaleRanking('person', 'Short', 'director', '');										 
SELECT * FROM multiScaleRanking('person', 'Short', '', 'US');										 
SELECT * FROM multiScaleRanking('person', 'Short', '', '');
SELECT * FROM multiScaleRanking('person', '', 'director', 'US');										 
SELECT * FROM multiScaleRanking('person', '', 'director', '');										 
SELECT * FROM multiScaleRanking('person', '', '', 'US');										 
SELECT * FROM multiScaleRanking('person', '', '', '');
																		 
SELECT * FROM multiScaleRanking('movie', 'Short', '', 'US');										 
SELECT * FROM multiScaleRanking('movie', 'Short', '', '');	
SELECT * FROM multiScaleRanking('movie', '', '', 'US');										 
SELECT * FROM multiScaleRanking('movie', '', '', '');
								 
SELECT * FROM multiScaleRanking('abc', '', '', '');
*/
