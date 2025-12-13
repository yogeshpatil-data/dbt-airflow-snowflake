{{ config(
    materialized = 'incremental',
    unique_key = 'rating_id'
) }}

with source as (

    select
        userId      as user_id,
        movieId     as movie_id,
        rating,
        to_timestamp(timestamp) as rated_at
    from {{ source('movielens_raw', 'ratings') }}

    {% if is_incremental() %}
        where to_timestamp(timestamp) > (select max(rated_at) from {{ this }})
    {% endif %}
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
