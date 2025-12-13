
  
    

create or replace transient table NETFLIX_DB.DEV_STAGING.stg_tags
    
    
    
    as (

with source as (

    select
        userId     as user_id,
        movieId    as movie_id,
        tag,
        to_timestamp(timestamp) as tagged_at
    from NETFLIX_DB.RAW.tags

    
),

final as (
    select
        md5(user_id || '-' || movie_id || '-' || tagged_at || '-' || tag) as tag_id,
        user_id,
        movie_id,
        tag,
        tagged_at
    from source
)

select * from final
    )
;


  