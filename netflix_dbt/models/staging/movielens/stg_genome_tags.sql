{{ config(materialized='view') }}

select
    tagId  as tag_id,
    tag
from {{ source('movielens_raw', 'genome_tags') }}