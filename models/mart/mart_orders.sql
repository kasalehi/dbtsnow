-- lets define custome schema for mart_orders
{{config(
    materialized='view',
    schema='mart',
)}}

select 
    order_id,
    customer_id,
    order_date,
    quantity,
    payment_method,
    total_amount,
    status
from {{ ref('stg_orders') }}
where quantity >= 2