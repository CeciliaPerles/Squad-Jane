{{ config(materialized='table') }}

select *
from read_parquet('/opt/airflow/tmp/ecommerce.parquet')
