with source as (
    select * from {{ source('web_tracking', 'pageviews') }}
)

, renamed as (
    select
        *
        -- timestamps

        -- excluded columns      


    from source
)

select * from renamed