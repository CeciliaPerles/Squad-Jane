{{ config(materialized='table') }}

select
    count(*) as total_clientes,
    sum(case when s.churn = 1 then 1 else 0 end) as clientes_churn,
    round(
        sum(case when s.churn = 1 then 1 else 0 end) * 1.0 / count(*),
        4
    ) as taxa_churn,
    round(avg(c.valor_cliente_tempo_vida), 2) as media_clv,
    round(avg(c.valor_total_gasto), 2) as media_total_gasto,
    round(avg(s.nota_satisfacao), 2) as media_satisfacao,
    round(
        sum(case when s.teve_reclamacao = 1 then 1 else 0 end) * 1.0 / count(*),
        4
    ) as taxa_reclamacao,
    round(avg(c.dias_desde_ultimo_pedido), 2) as media_dias_desde_ultimo_pedido

from {{ ref('silver_status') }} s
left join {{ ref('silver_consumo') }} c
    on s.id_cliente = c.id_cliente