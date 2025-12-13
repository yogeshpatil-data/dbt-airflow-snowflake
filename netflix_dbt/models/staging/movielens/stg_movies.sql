{{ config(
    materialized = 'view'
) }}

select
    movieId     as movie_id,
    title,
    genres
from {{ source('movielens_raw', 'movies') }}