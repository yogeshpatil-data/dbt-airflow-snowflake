{% macro null_safe_divide(numerator, denominator) %}
    /*
    Macro: null_safe_divide

    Purpose:
    Performs safe division without raising divide-by-zero errors.

    Why:
    Metrics like averages and ratios must never fail due to zero denominators.

    Behavior:
    - If denominator = 0 or NULL → returns NULL
    - Else → returns numerator / denominator
    */

    case
        when {{ denominator }} = 0 or {{ denominator }} is null then null
        else {{ numerator }} / {{ denominator }}
    end
{% endmacro %}

/* Usage
select
    movie_id,
    count(*) as rating_count,
    {{ null_safe_divide('sum(rating)', 'count(*)') }} as avg_rating
from {{ ref('stg_ratings') }}
group by movie_id
*/