{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_id',
        cluster_by=['order_date'],
        incremental_predicates=[
            "DBT_INTERNAL_DEST.order_date >= dateadd(day, -7, current_date)"
        ]
    )
}}

select
    order_id,
    customer_id,
    order_date,
    quantity,
    payment_method,
    total_amount,
    status
from {{ source('stg', 'orders') }}
{% if is_incremental() %}
where order_date >= (
    select dateadd(day, -3, max(order_date)) from {{ this }}
)
{% endif %}