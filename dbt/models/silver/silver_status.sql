{{ config(materialized='table') }}

select
    CustomerID as id_cliente,
    Churn as churn,
    Tenure as tempo_como_cliente,
    SatisfactionScore as nota_satisfacao,
    Complain as teve_reclamacao,
    CityTier as nivel_cidade,
    WarehouseToHome as distancia_estoque_residencia,
    NumberOfAddress as quantidade_enderecos
from {{ ref('bronze_ecommerce') }}