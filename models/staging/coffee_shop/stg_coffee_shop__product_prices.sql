with source as (
    select * from {{ source('coffee_shop', 'product_prices') }}
)

, renamed as (
    select
        id as price_id
        , product_id
        , price

        -- timestamps
        , created_at as price_start_date
        , ended_at as price_end_date
        -- excluded columns      


    from source
)

select * from renamed