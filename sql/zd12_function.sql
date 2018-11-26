
create or replace function movieRecommendation_1(movieName varchar(1000), movieId char(10) ) returns 
table (movie_id CHAR(10), recommend_movie VARCHAR(1000), recommendation_value numeric) as
$$
declare
	nums1 integer;
	nums2 integer;
	queryString text;
begin
	execute 'select count(*) from recommend_movie where movie_id = '||QUOTE_LITERAL(movieId) into nums1;
	execute 'select count(*) from recommend_movie where title = '||QUOTE_LITERAL(movieName) into nums2;
	if movieName != '' and movieId != '' then
		raise exception 'You are only allowed to input one value: movieName or movieId';
	end if;
	if (nums1>0) then
		queryString = 'select recommend_movie_id, recommend_movie, recommendation_value 
					   from recommend_movie 
					   where movie_id =' || QUOTE_LITERAL(movieId) ||
					   'limit 10';
		return QUERY execute queryString;
	end if; 
	
  	if (nums2>0) then
 		queryString = 'select recommend_movie_id, recommend_movie, recommendation_value 
  					   from recommend_movie 
 					   where title = '||QUOTE_LITERAL(movieName) ||
  					   'limit 10';
  		return QUERY execute queryString;
  	end if;
	
 	if nums1=0 and nums2=0 then
 		RAISE EXCEPTION 'This movie is not in the record';
 	end if;
end;
$$
language plpgsql;

-- test case										
select * from movieRecommendation_1('Don''t', '');
select * from movieRecommendation_1('', 'tt0071430');	
select * from movieRecommendation_1('', 'tt0086353');
select * from movieRecommendation_1('Don''t', 'tt0086353');
																	 
																					 
															
																