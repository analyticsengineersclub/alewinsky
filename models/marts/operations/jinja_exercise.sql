{% set coffee_types = ['coffee_beans', 'merch', 'brewing_supplies', ] %}

select
  date_trunc(order_date, month) as date_month,
  {% for coffee_type in coffee_types %}
  sum(case when product_category = '{{ coffee_type }}' then price end) as {{ coffee_type }}_amount,
  {% endfor %}
from {{ ref('order_item_rev') }}
group by 1





-- {% set me = 'andrew' %}
-- {{ me }}

-- select
--   date_trunc(order_date, month) as date_month,
--   sum(case when product_category = 'coffee beans' then price end) as coffee_beans_amount,
--   sum(case when product_category = 'merch' then price end) as merch_amount,
--   sum(case when product_category = 'brewing supplies' then price end) as brewing_supplies_amount
-- -- you may have to `ref` a different model here, depending on what you've built previously
-- from {{ ref('order_item_rev') }}
-- group by 1