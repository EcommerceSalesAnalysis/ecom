{{ config(
    materialized='table'  
) }}

SELECT
    SHIP_STATE,
    Category,
    ASIN,
    SUM(total_qty_sold) AS total_qty_sold,  -- Total quantity sold in each state and category
    SUM(shipped_revenue) AS total_revenue,  -- Total revenue from shipped orders
    AVG(shipped_revenue / NULLIF(total_qty_sold, 0)) AS avg_order_value,  -- Average order value from shipped orders
    SUM(total_returns) AS total_returns,  -- Total returns in each state and category
    SUM(total_cancellations) AS total_cancellations,  -- Total cancellations in each state and category
    SUM(total_returns) / NULLIF(SUM(shipped_revenue), 0) * 100 AS return_rate,  -- Return rate as a percentage
    SUM(total_cancellations) / NULLIF(SUM(shipped_revenue), 0) * 100 AS cancellation_rate  -- Cancellation rate as a percentage
FROM
    {{ ref('int_sales_summary') }}
GROUP BY
    SHIP_STATE, Category, ASIN