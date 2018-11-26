/*
	First, choose 10000 samples by join movie, person, genre, and assign.
	Second, take genre, actor, director, actress, isAdult, releaseYear as parameters to calculate jaccard similarity respectively.
	Third, calculate the total similarity. Every parameter has its own weight.
	Fourth, combine similarity and ratings as a recommendation value.
*/
drop table if exists recommend_movie;
drop materialized view if exists recommend_movie_previous;
drop materialized view if exists similarity;

drop materialized view if exists single_similarity;
drop materialized view if exists single;

drop materialized view if exists role_similarity;

drop materialized view if exists director_similiarity;
drop materialized view if exists intersection_sets_director;
drop materialized view if exists union_sets_director;
drop materialized view if exists jaccard_director_final;
drop materialized view if exists jaccard_director;

drop materialized view if exists actress_similiarity;
drop materialized view if exists intersection_sets_actress;
drop materialized view if exists union_sets_actress;
drop materialized view if exists jaccard_actress_final;
drop materialized view if exists jaccard_actress;

drop materialized view if exists actor_similiarity;
drop materialized view if exists intersection_sets_actor;
drop materialized view if exists union_sets_actor;
drop materialized view if exists jaccard_actor_final;
drop materialized view if exists jaccard_actor;

drop materialized view if exists jaccard_role;

drop materialized view if exists genre_similiarity;
drop materialized view if exists intersection_sets_genre;
drop materialized view if exists union_sets_genre;
drop materialized view if exists jaccard_genres;
drop table if exists all_information;

create table all_information as 
select  m.movieid, m.releaseyear, m.isadult, m.rating, m.numvotes, a.personid, r.roleid, g.type
from    movie m, assign a, role r, person p, genre g
where   m.movieid=a.movieid and a.personid=p.personid and a.roleid=r.roleid and g.movieid = m.movieid and numvotes>0 
		and r.type in ('actress', 'director','actor')
limit 10000;

-- select count(distinct(movieid)) from all_information

-- jaccard_genres
create materialized view jaccard_genres as
select movieid, type
from all_information 
group by movieid, type
order by movieid 

create index movieindex on jaccard_genres(movieid);
create index typeindex on jaccard_genres(type);

create materialized view union_sets_genre as
select temp1.id_1, temp1.id_2, count(*)
from (
		(select j1.movieid as id_1, j2.movieid as id_2, j1.type as type_1
		from jaccard_genres j1 left join jaccard_genres j2 on j1.movieid!=j2.movieid)
		union
		(select j3.movieid as id_1, j4.movieid as id_2, j4.type as type_2
		from jaccard_genres j3 left join jaccard_genres j4 on j3.movieid!=j4.movieid)
	)temp1
group by temp1.id_1, temp1.id_2;

create materialized view intersection_sets_genre as
select j1.movieid as id_1, j2.movieid as id_2, count(*)
from jaccard_genres j1 left join jaccard_genres j2 on j1.movieid!=j2.movieid
where j1.type=j2.type
group by j1.movieid, j2.movieid;

create materialized view genre_similiarity as
select   
		set1.id_1, 
		set1.id_2, 
		case
			when set1.count = 0 then 1
			when set2.count is null then 0
    		else cast(cast(set2.count as numeric)/cast(set1.count as numeric)as numeric(10,2)) 
		end as jaccard_index												
from union_sets_genre set1 left join intersection_sets_genre set2 on set1.id_1=set2.id_1 and set1.id_2=set2.id_2;
																						
-- jaccard_role																						
create materialized view jaccard_role as
select a.movieid, a.personid
from all_information a left join role r on a.roleid=r.roleid 
group by a.movieid, a.personid
order by a.movieid;

-- actor_similiarity
create materialized view jaccard_actor as
select a.movieid, a.personid
from all_information a left join role r on a.roleid=r.roleid 
where r.type = 'actor'
group by a.movieid, a.personid
order by a.movieid;																						
																						
create materialized view jaccard_actor_final as
select j2.movieid, j1.personid  
from jaccard_role j2 left join jaccard_actor j1 on j1.movieid = j2.movieid
group by j2.movieid, j1.personid
order by j2.movieid;																						
																						
create index movieindex1 on jaccard_actor_final(movieid);
create index personindex1 on jaccard_actor_final(personid);																						
																						
create materialized view union_sets_actor as
select temp1.id_1, temp1.id_2, count(*)
from (
		(select j1.movieid as id_1, j2.movieid as id_2, j1.personid as personid_1
		from jaccard_actor_final j1 left join jaccard_actor_final j2 on j1.movieid!=j2.movieid)
		union
		(select j3.movieid as id_1, j4.movieid as id_2, j4.personid as personid_2
		from jaccard_actor_final j3 left join jaccard_actor_final j4 on j3.movieid!=j4.movieid)
	)temp1
group by temp1.id_1, temp1.id_2;																						
																						
create materialized view intersection_sets_actor as
select j1.movieid as id_1, j2.movieid as id_2, count(*)
from jaccard_actor_final j1 left join jaccard_actor_final j2 on j1.movieid!=j2.movieid 
where j1.personid=j2.personid
group by j1.movieid, j2.movieid
order by j1.movieid;																						

create materialized view actor_similiarity as
select   
		set1.id_1, 
		set1.id_2, 
		case
			when set1.count = 0 then 1
			when set2.count is null then 0
    		else cast(cast(set2.count as numeric)/cast(set1.count as numeric)as numeric(10,2)) 
		end as jaccard_index												
from union_sets_actor set1 left join intersection_sets_actor set2 on set1.id_1=set2.id_1 and set1.id_2=set2.id_2;
-- select count(*) from actor_similiarity
																						
-- actress similarity
create materialized view jaccard_actress as
select a.movieid, a.personid
from all_information a left join role r on a.roleid=r.roleid 
where r.type = 'actress'
group by a.movieid, a.personid
order by a.movieid;	
																						
create materialized view jaccard_actress_final as
select j2.movieid, j1.personid  
from jaccard_role j2 left join jaccard_actress j1 on j1.movieid = j2.movieid
group by j2.movieid, j1.personid
order by j2.movieid;
																						
create index movieindex3 on jaccard_actress_final(movieid);
create index personindex3 on jaccard_actress_final(personid);
	
create materialized view union_sets_actress as
select temp1.id_1, temp1.id_2, count(*)
from (
		(select j1.movieid as id_1, j2.movieid as id_2, j1.personid as personid_1
		from jaccard_actress_final j1 left join jaccard_actress_final j2 on j1.movieid !=j2.movieid)
		union
		(select j3.movieid as id_1, j4.movieid as id_2, j4.personid as personid_2
		from jaccard_actress_final j3 left join jaccard_actress_final j4 on j3.movieid!=j4.movieid)
	)temp1
group by temp1.id_1, temp1.id_2;

create materialized view intersection_sets_actress as
select j1.movieid as id_1, j2.movieid as id_2, count(*)
from jaccard_actress_final j1 left join jaccard_actress_final j2 on j1.movieid!=j2.movieid 
where j1.personid=j2.personid
group by j1.movieid, j2.movieid
order by j1.movieid;

create materialized view actress_similiarity as
select   
		set1.id_1, 
		set1.id_2, 
		case
			when set1.count = 0 then 1
			when set2.count is null then 0
    		else cast(cast(set2.count as numeric)/cast(set1.count as numeric)as numeric(10,2)) 
		end as jaccard_index												
from union_sets_actress set1 left join intersection_sets_actress set2 on set1.id_1=set2.id_1 and set1.id_2=set2.id_2;
-- select count(*) from actress_similiarity	
																						
create materialized view jaccard_director as
select a.movieid, a.personid
from all_information a left join role r on a.roleid=r.roleid 
where r.type = 'director'
group by a.movieid, a.personid
order by a.movieid;	
																						
create materialized view jaccard_director_final as
select j2.movieid, j1.personid  
from jaccard_role j2 left join jaccard_director j1 on j1.movieid = j2.movieid
group by j2.movieid, j1.personid
order by j2.movieid;
																						
create index movieindex4 on jaccard_director_final(movieid);
create index personindex4 on jaccard_director_final(personid);	

create materialized view union_sets_director as
select temp1.id_1, temp1.id_2, count(*)
from (
		(select j1.movieid as id_1, j2.movieid as id_2, j1.personid as personid_1
		from jaccard_director_final j1 left join jaccard_director_final j2 on j1.movieid!=j2.movieid)
		union
		(select j3.movieid as id_1, j4.movieid as id_2, j4.personid as personid_2
		from jaccard_director_final j3 left join jaccard_director_final j4 on j3.movieid!=j4.movieid)
	)temp1
group by temp1.id_1, temp1.id_2;

create materialized view intersection_sets_director as
select j1.movieid as id_1, j2.movieid as id_2, count(*)
from jaccard_director_final j1 left join jaccard_director_final j2 on j1.movieid!=j2.movieid 
where j1.personid=j2.personid
group by j1.movieid, j2.movieid
order by j1.movieid;

create materialized view director_similiarity as
select   
		set1.id_1, 
		set1.id_2, 
		case
			when set1.count = 0 then 1
			when set2.count is null then 0
    		else cast(cast(set2.count as numeric)/cast(set1.count as numeric)as numeric(10,2)) 
		end as jaccard_index												
from union_sets_director set1 left join intersection_sets_director set2 on set1.id_1=set2.id_1 and set1.id_2=set2.id_2;
-- select count(*) from director_similiarity where jaccard_index>0
																						
create index id_1_actor on actor_similiarity(id_1);
create index id_2_actor on actor_similiarity(id_2);
create index id_1_director on director_similiarity(id_1);
create index id_2_director on director_similiarity(id_2);
create index id_1_actress on actress_similiarity(id_1);
create index id_2_actress on actress_similiarity(id_2);
																						
-- role_similarity
create materialized view role_similarity as
select r.id_1, r.id_2, r.jaccard_index as actor_similarity, d.jaccard_index as director_similarity, s.jaccard_index as actress_similarity																				
from actor_similiarity r, director_similiarity d, actress_similiarity s																						
where r.id_1=d.id_1 and r.id_2=d.id_2 and s.id_1=d.id_1	and	s.id_2=d.id_2;	
																																											
create materialized view single as
select movieid, isadult, releaseYear
from all_information
group by movieid, isadult, releaseYear;											
																						
create materialized view single_similarity as
select s1.movieid as id_1, s2.movieid as id_2, 
		case 
			when s1.isadult = s2.isadult then 1
			else 0 
	 	end as isAdult_similarity,
		case 
			when abs(s1.releaseYear-s2.releaseYear)<=10 then 1
			else 0 
	 	end as releaseYear_similarity
from single s1 left join single s2 on s1.movieid != s2.movieid;																						
																						
create materialized view similarity as
select ss.id_1, ss.id_2, 
	cast(gs.jaccard_index * 0.6 + 
		 (ss.isAdult_similarity + ss.releaseYear_similarity)*0.05+ 
		 (rs.actor_similarity + rs.director_similarity + rs.actress_similarity)*0.1 as numeric) as similarity
from single_similarity ss , role_similarity rs , genre_similiarity gs
where ss.id_1=rs.id_1 and ss.id_2=rs.id_2 and rs.id_1=gs.id_1 and rs.id_2=gs.id_2;

create materialized view recommend_movie_previous as																				
select s.id_1 as movie_id, s.id_2 as recommend_movie_id, m.title as recommend_movie, (s.similarity * 10 * 0.4 + m.rating*0.6) as recommendation_value
from similarity s, movie m
where s.id_2=m.movieid
order by s.id_1, recommendation_value desc
																						
create table recommend_movie as																						
select movie_id, m.title, rm.recommend_movie_id, rm.recommend_movie, rm.recommendation_value
from recommend_movie_previous rm, movie m																					
where rm.movie_id = m.movieid and rm.recommendation_value >	5.5																					
order by rm.movie_id, recommendation_value desc	
																						
																					
																						
																						