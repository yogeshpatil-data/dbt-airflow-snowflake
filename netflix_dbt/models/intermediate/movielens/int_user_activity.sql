{{ config(materialized='table') }}

with ratings as (
    select user_id, rating
    from {{ ref('stg_ratings') }}
),

tags as (
    select user_id
    from {{ ref('stg_tags') }}
),

user_ratings as (
    select
        user_id,
        count(*) as total_ratings,
        avg(rating) as avg_rating
    from ratings
    group by user_id
),

user_tags as (
    select
        user_id,
        count(*) as total_tags
    from tags
    group by user_id
)

select
    r.user_id,
    r.total_ratings,
    r.avg_rating,
    coalesce(t.total_tags, 0) as total_tags
from user_ratings r
left join user_tags t 
    on r.user_id = t.user_id