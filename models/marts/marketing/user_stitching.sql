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
    limit 10
)


select
*
from customer_visit_count