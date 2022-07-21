with source as (
    select * from {{ source('coffee_shop', 'customers') }}
)

, renamed as (
    select
        id as customer_id
        , name as customer_name
        , email as customer_email

        -- timestamps

        -- excluded columns      


    from source
)

select * from renamed