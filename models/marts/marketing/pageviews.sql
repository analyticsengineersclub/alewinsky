{{ config (
  materialized='table'
)}} --assume by default this will be table per dbt_project.yml file

with

pageviews as (
  select * from {{ ref('stg_web_tracking__pageviews') }}
)

, customer_visit_count as (
    select
    *
    , count(visitor_id) over (partition by customer_id order by timestamp) as repeat_visits
    from pageviews
)

--to get the very first visitor_id associated with a customer_id
, first_visit_only as (
  select
  *
  from customer_visit_count
  where repeat_visits = 1
)


select
customer_visit_count.pageview_id
, first_visit_only.visitor_id as visitor_id
, customer_visit_count.customer_id
, customer_visit_count.device_type
, customer_visit_count.page
, customer_visit_count.timestamp
, customer_visit_count.repeat_visits
-- , customer_visit_count_2.timestamp as prev_visit_timestamp
-- , customer_visit_count_2.device_type as prev_visit_device_type
-- , customer_visit_count.timestamp - customer_visit_count_2.timestamp as time_between_views
-- , case
--     when customer_visit_count.timestamp - customer_visit_count_2.timestamp < 30
--     then true
--     else false
--     end as combined_session
from customer_visit_count
left join first_visit_only on customer_visit_count.customer_id = first_visit_only.customer_id
left join customer_visit_count customer_visit_count_2 on customer_visit_count.visitor_id = customer_visit_count_2.visitor_id and customer_visit_count.repeat_visits = customer_visit_count_2.repeat_visits - 1