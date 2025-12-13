select
    movie_id,
    title,
    genres
from {{ ref('stg_movies') }}
