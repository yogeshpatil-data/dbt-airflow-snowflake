{{ config(
    materialized = 'incremental',
    unique_key = 'tag_id'
) }}

with source as (

    select
        userId     as user_id,
        movieId    as movie_id,
        tag,
        to_timestamp(timestamp) as tagged_at
    from {{ source('movielens_raw', 'tags') }}

    {% if is_incremental() %}
        where to_timestamp(timestamp) > (select max(tagged_at) from {{ this }})
    {% endif %}
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