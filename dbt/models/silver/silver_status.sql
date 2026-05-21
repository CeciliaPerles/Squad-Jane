{{ config(materialized='table') }}

select
    CustomerID as id_cliente,
    case
        when lower(trim(replace(replace(Churn, '"', ''), chr(9), ''))) in ('1', 'true', 'yes', 'y', 'sim')
            then 1
        when lower(trim(replace(replace(Churn, '"', ''), chr(9), ''))) in ('0', 'false', 'no', 'n', 'não', 'nao')
            then 0
        else null
    end as churn,
    Tenure as tempo_como_cliente,
    SatisfactionScore as nota_satisfacao,
    case
        when lower(trim(replace(replace(Complain, '"', ''), chr(9), ''))) in ('1', 'true', 'yes', 'y', 'sim')
            then 1
        when lower(trim(replace(replace(Complain, '"', ''), chr(9), ''))) in ('0', 'false', 'no', 'n', 'não', 'nao')
            then 0
        else null
    end as teve_reclamacao,
    CityTier as nivel_cidade,
    WarehouseToHome as distancia_estoque_residencia,
    NumberOfAddress as quantidade_enderecos

from {{ ref('bronze_ecommerce') }}