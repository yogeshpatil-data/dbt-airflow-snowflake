{% snapshot snap_movies %}
    /*
    Snapshot: snap_movies

    Purpose:
    Tracks historical changes to movie metadata over time.

    Business Reason:
    Movie titles and genres may change after ingestion.
    Analytics and audits often require historical correctness.

    Strategy:
    - Uses 'check' strategy
    - Tracks changes in title and genres
    */

    {{
        config(
            target_schema='SNAPSHOTS',
            unique_key='movie_id',
            strategy='check',
            check_cols=['title', 'genres']  /*another starategy possible strategy:timestamp
        )
    }}

    select
        movie_id,
        title,
        genres
    from {{ ref('stg_movies') }}

{% endsnapshot %}
