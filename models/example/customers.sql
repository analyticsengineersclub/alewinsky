{{ config (
  materialized='table'
)}}

with customer_aggs as (
  select
  customer_id
  , min(created_at) as first_order_at
  , coalesce(count(*),0) as number_of_orders
  from {{ source('coffee_shop', 'orders') }}
  group by 1
)

select
c.id as customer_id
, c.name
, c. email
, ca.first_order_at
, ca.number_of_orders
from {{ source('coffee_shop', 'customers') }} c
left join customer_aggs ca on c.id = ca.customer_id
order by first_order_at
limit 5