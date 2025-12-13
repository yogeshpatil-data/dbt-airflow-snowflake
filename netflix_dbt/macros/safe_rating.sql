{% macro safe_rating(column_name) %}
    /*
    Macro: safe_rating

    Purpose:
    Ensures rating values stay within the valid business range (0–5).

    Why:
    Raw ingestion sources may contain invalid ratings.
    This macro centralizes validation logic so it is not duplicated across models.

    Behavior:
    - Ratings < 0   → NULL
    - Ratings > 5   → NULL
    - Valid ratings → returned as-is
    */

    case
        when {{ column_name }} < 0 then null
        when {{ column_name }} > 5 then null
        else {{ column_name }}
    end
{% endmacro %}
