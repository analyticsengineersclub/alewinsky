{{ config (
  materialized='table'
)}}

with

orders as (
  select * from {{ ref('stg_coffee_shop__orders') }}
)

, customers as (
  select * from {{ ref('stg_coffee_shop__customers') }}
)

, customer_aggs as (
  select
  customer_id
  , min(order_date) as first_order_at
  , coalesce(count(*),0) as number_of_orders
  from orders
  group by 1
)

select
c.customer_id
, customer_name
, customer_email
, ca.first_order_at
, ca.number_of_orders
from customers c
left join customer_aggs ca on c.customer_id = ca.customer_id
order by first_order_at