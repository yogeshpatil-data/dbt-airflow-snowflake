
  create or replace   view NETFLIX_DB.STAGING.stg_netflix_titles
  
  
  
  
  as (
    
-- Source: raw data loaded from S3 stage
select
    t.$1::string as show_id,
    t.$2::string as title,
    t.$3::string as type,
    t.$4::string as director,
    t.$5::string as cast,
    t.$6::string as country,
    t.$7::string as date_added,
    t.$8::string as release_year,
    t.$9::string as rating,
    t.$10::string as duration,
    t.$11::string as listed_in,
    t.$12::string as description
from @NETFLIX_DB.RAW.S3_STAGE_NETFLIX t
  );

