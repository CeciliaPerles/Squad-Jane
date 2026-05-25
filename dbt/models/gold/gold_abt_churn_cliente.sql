{{ config(materialized='table') }}

select
    s.id_cliente,
    s.churn,
    s.tempo_como_cliente,
    s.nota_satisfacao,
    s.teve_reclamacao,
    s.nivel_cidade,
    s.distancia_estoque_residencia,
    s.quantidade_enderecos,

    pref.dispositivo_login_preferido,
    pref.forma_pagamento_preferida,
    pref.categoria_pedido_preferida,
    pref.horario_entrega_preferido,
    pref.horas_no_app,
    pref.quantidade_dispositivos_registrados,
    pref.avaliacao_app,
    pref.inscrito_email,
    pref.notificacoes_push_ativas,

    p.genero,
    p.idade,
    p.cidade,
    p.faixa_renda,
    p.nivel_educacao,
    p.ocupacao,
    p.estado_civil,
    p.possui_filhos,
    p.quantidade_filhos,
    p.status_emprego,

    c.quantidade_pedidos,
    c.cupons_utilizados,
    c.dias_desde_ultimo_pedido,
    c.valor_cashback,
    c.valor_total_gasto,
    c.valor_cliente_tempo_vida,
    c.taxa_devolucao,
    c.categoria_ultima_compra,
    c.data_cadastro,
    c.data_ultima_compra,

    case
        when s.tempo_como_cliente > 0
        then c.quantidade_pedidos * 1.0 / s.tempo_como_cliente
        else null
    end as frequencia_mensal_compra,

    case
        when c.quantidade_pedidos > 0
        then c.valor_total_gasto / c.quantidade_pedidos
        else null
    end as ticket_medio,

    case
        when c.valor_total_gasto > 0
        then c.valor_cashback / c.valor_total_gasto
        else null
    end as eficiencia_cashback,

    case
        when s.teve_reclamacao = 1
         and s.nota_satisfacao <= 2
         and c.taxa_devolucao > 0
        then 1
        else 0
    end as perfil_problematico,

    case
        when c.dias_desde_ultimo_pedido > 30
        then 1
        else 0
    end as cliente_inativo

from {{ ref('silver_status') }} s

left join {{ ref('silver_preferencias') }} pref
    on s.id_cliente = pref.id_cliente

left join {{ ref('silver_perfil') }} p
    on s.id_cliente = p.id_cliente

left join {{ ref('silver_consumo') }} c
    on s.id_cliente = c.id_cliente