select
    r.movie_id,
    r.rating_count,
    r.avg_rating
from {{ ref('int_movie_ratings') }} r
