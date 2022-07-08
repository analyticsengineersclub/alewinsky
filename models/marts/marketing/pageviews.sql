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
    , count(visitor_id) over (partition by customer_id order by timestamp) as visit_num
    from pageviews
)

--to get the very first visitor_id associated with a customer_id
, first_visit_only as (
  select
  *
  from customer_visit_count
  where visit_num = 1
)

select
cvc.pageview_id
, fvo.visitor_id as visitor_id
, cvc.customer_id
, cvc.device_type
, cvc.page
, cvc.timestamp
, cvc.visit_num
, cvc2.timestamp as prev_visit_timestamp
, cvc2.device_type as prev_visit_device_type
, cvc.timestamp - cvc2.timestamp as time_between_views
, TIMESTAMP_DIFF(cvc.timestamp, cvc2.timestamp, MINUTE) as minutes_since_prev_visit
, TIMESTAMP_DIFF(cvc.timestamp, cvc2.timestamp, MINUTE) < 30 as combined_session
, count(*) over (partition by cvc.visitor_id order by cvc.timestamp) as session_id
from customer_visit_count cvc
left join first_visit_only fvo on cvc.customer_id = fvo.customer_id 
left join customer_visit_count cvc2 on cvc.visitor_id = cvc2.visitor_id and cvc.visit_num = cvc2.visit_num + 1