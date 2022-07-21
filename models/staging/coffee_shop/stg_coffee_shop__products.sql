with source as (
    select * from {{ source('coffee_shop', 'products') }}
)

, renamed as (
    select
        id as product_id
        , name as product_name
-- string manipulation to change coffee beans to coffee_beans and to change brewing supplies to brewing_supplies
        , case
            when category = 'coffee beans'
            then 'coffee_beans'
            else case
                when category = 'brewing supplies'
                then 'brewing_supplies'
                else category
                end
            end as product_category
        -- timestamps
        , created_at as product_created_at
        -- excluded columns      


    from source
)

select * from renamed