
  create or replace   view NETFLIX_DB.DEV_STAGING.stg_genome_tags
  
  
  
  
  as (
    

select
    tagId  as tag_id,
    tag
from NETFLIX_DB.RAW.genome_tags
  );

