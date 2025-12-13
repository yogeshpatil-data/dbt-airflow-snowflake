{{ config(materialized='table') }}

with scores as (
    select
        movie_id,
        tag_id,
        relevance
    from {{ ref('stg_genome_scores') }}
),

tags as (
    select
        tag_id,
        tag as tag_description
    from {{ ref('stg_genome_tags') }}
)

select
    s.movie_id,
    s.tag_id,
    t.tag_description,
    s.relevance
from scores s
left join tags t using (tag_id)