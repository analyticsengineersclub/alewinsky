{{ config (
  materialized='table'
)}}

with

orders as (
  select * from {{ ref('stg_coffee_shop__orders') }}
)

, customers as (
  select * from {{ ref('customers') }}
)

, order_items as (
  select * from {{ ref('stg_coffee_shop__order_items') }}
)

, product_prices as (
  select * from {{ ref('stg_coffee_shop__product_prices') }}
)

, products as (
  select * from {{ ref('stg_coffee_shop__products') }}
)

select
oi.order_item_id
, o.order_date
, p.product_name
, p.product_category
, pp.price
, case
    when o.order_date = c.first_order_at
    then true
    else false
    end as new_customer_order
from order_items oi
left join orders o on oi.order_id = o.order_id
left join products p on oi.product_id = p.product_id
--Adding an extra hour to the price end date in order to account for cut-off misalignment
left join product_prices pp on oi.product_id = pp.product_id and o.order_date between pp.price_start_date and DATE_ADD(price_end_date, INTERVAL 1 HOUR)
left join customers c on o.customer_id = c.customer_id