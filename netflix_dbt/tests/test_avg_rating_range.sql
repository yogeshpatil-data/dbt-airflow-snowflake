/*
Test: test_avg_rating_range

Purpose:
Ensures calculated average ratings stay within valid bounds.

Why:
Prevents incorrect aggregations and dashboard corruption.

Test Logic:
Returns rows where avg_rating is invalid.
Test passes only if zero rows are returned.
*/

select *
from {{ ref('fct_movie_ratings') }}
where avg_rating < 0
   or avg_rating > 5
