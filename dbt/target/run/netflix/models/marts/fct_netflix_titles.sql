
  
    

create or replace transient table NETFLIX_DB.STAGING.fct_netflix_titles
    
    
    
    as (

select *
from NETFLIX_DB.STAGING.stg_netflix_titles
    )
;


  