{{ config(
    materialized = 'incremental',
    unique_key = 'composite_id'
) }}

with source as (

    select
        movieId as movie_id,
        tagId   as tag_id,
        relevance
    from {{ source('movielens_raw', 'genome_scores') }}

    {% if is_incremental() %}
        where movieId > (select max(movie_id) from {{ this }})
    {% endif %}
),

final as (
    select
        md5(movie_id || '-' || tag_id) as composite_id,
        movie_id,
        tag_id,
        relevance
    from source
)

select * from final