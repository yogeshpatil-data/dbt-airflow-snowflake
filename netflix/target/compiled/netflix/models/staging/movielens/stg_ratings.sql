

with source as (

    select
        userId      as user_id,
        movieId     as movie_id,
        rating,
        to_timestamp(timestamp) as rated_at
    from NETFLIX_DB.RAW.ratings

    
),

final as (
    select
        md5(user_id || '-' || movie_id || '-' || rated_at) as rating_id,
        user_id,
        movie_id,
        rating,
        rated_at
    from source
)

select * from final