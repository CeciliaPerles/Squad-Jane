{{ config(materialized='table') }}

select
    p.faixa_renda,
    p.genero,
    p.nivel_educacao,
    p.status_emprego,

    pref.categoria_pedido_preferida,
    pref.forma_pagamento_preferida,
    pref.dispositivo_login_preferido,

    count(*) as total_clientes,

    sum(case when s.churn = 1 then 1 else 0 end) as clientes_churn,

    round(
        sum(case when s.churn = 1 then 1 else 0 end) * 1.0 / count(*),
        4
    ) as taxa_churn,

    round(avg(c.valor_cliente_tempo_vida), 2) as media_clv,
    round(avg(s.nota_satisfacao), 2) as media_satisfacao,
    round(avg(c.valor_total_gasto), 2) as media_total_gasto,
    round(avg(c.taxa_devolucao), 4) as media_taxa_devolucao,
    round(avg(pref.horas_no_app), 2) as media_horas_no_app

from {{ ref('silver_status') }} s

left join {{ ref('silver_perfil') }} p
    on s.id_cliente = p.id_cliente

left join {{ ref('silver_preferencias') }} pref
    on s.id_cliente = pref.id_cliente

left join {{ ref('silver_consumo') }} c
    on s.id_cliente = c.id_cliente

group by
    p.faixa_renda,
    p.genero,
    p.nivel_educacao,
    p.status_emprego,
    pref.categoria_pedido_preferida,
    pref.forma_pagamento_preferida,
    pref.dispositivo_login_preferido