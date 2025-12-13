
  create or replace   view NETFLIX_DB.DEV_STAGING.stg_movies
  
  
  
  
  as (
    

select
    movieId     as movie_id,
    title,
    genres
from NETFLIX_DB.RAW.movies
  );

