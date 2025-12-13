/*
Test: test_rating_count_positive

Purpose:
Ensures fact table contains only meaningful records.

Why:
A fact record with zero ratings is logically invalid.

Test Logic:
Fails if any record has rating_count <= 0.
*/

select *
from {{ ref('fct_movie_ratings') }}
where rating_count <= 0
