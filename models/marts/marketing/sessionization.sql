{{ config (
  materialized='table'
)}} --assume by default this will be table per dbt_project.yml file

with

pageviews as (
  select * from {{ ref('stg_web_tracking__pageviews') }}
)

select
null as session_id
, *
from pageviews