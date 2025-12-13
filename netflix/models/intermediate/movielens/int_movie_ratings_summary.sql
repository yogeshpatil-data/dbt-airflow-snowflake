{{ config(materialized='table') }}

with ratings as (
    select
        movie_id,
        rating
    from {{ ref('stg_ratings') }}
),

summary as (
    select
        movie_id,
        count(*) as rating_count,
        avg(rating) as avg_rating,
        min(rating) as min_rating,
        max(rating) as max_rating
    from ratings
    group by movie_id
)

select * from summary
