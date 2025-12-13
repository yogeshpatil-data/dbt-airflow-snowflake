/*
Test: test_users_have_activity

Purpose:
Ensures no orphan users exist in the dimension table.

Why:
Dimensions must be derived from actual activity.

Test Logic:
Fails if any user exists in dim_users without ratings.
*/

select u.user_id
from {{ ref('dim_users') }} u
left join {{ ref('stg_ratings') }} r
  on u.user_id = r.user_id
where r.user_id is null
