with source as (
    select * from {{ source('coffee_shop', 'orders') }}
)

, renamed as (
    select
        id as order_id
        , customer_id
        , total as total --not sure what this field is. Range is from 12 to 69

        -- timestamps
        , created_at as order_date
        -- excluded columns      


    from source
)

select * from renamed