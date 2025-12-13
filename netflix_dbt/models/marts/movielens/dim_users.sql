select
    user_id
from {{ ref('stg_ratings') }}
group by user_id
