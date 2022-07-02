with source as (
    select * from {{ source('coffee_shop', 'order_items') }}
)

, renamed as (
    select
        id as order_item_id
        , order_id
        , product_id

        -- timestamps

        -- excluded columns      


    from source
)

select * from renamed