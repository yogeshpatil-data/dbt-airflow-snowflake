

with source as (

    select
        movieId as movie_id,
        tagId   as tag_id,
        relevance
    from NETFLIX_DB.RAW.genome_scores

    
),

final as (
    select
        md5(movie_id || '-' || tag_id) as composite_id,
        movie_id,
        tag_id,
        relevance
    from source
)

select * from final