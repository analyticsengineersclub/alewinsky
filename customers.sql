with customer_aggs as (
  select
  customer_id
  , min(created_at) as first_order_at
  , coalesce(count(*),0) as number_of_orders
  from `analytics-engineers-club.coffee_shop.orders`
  group by 1
)

select
o.customer_id
, name
, email
, first_order_at
, number_of_orders
from `analytics-engineers-club.coffee_shop.orders` o
left join customer_aggs ca on o.customer_id = ca.customer_id
left join `analytics-engineers-club.coffee_shop.customers` c on o.customer_id = c.id
order by first_order_at
limit 20
