{{ config(
    materialized='table',
    alias='ecommerce'
) }}

SELECT
    *
FROM
    bronze.ecommerce