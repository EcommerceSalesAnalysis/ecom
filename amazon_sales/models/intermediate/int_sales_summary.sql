{{ config(
    materialized='table'  
) }}

WITH base_data AS (
    SELECT 
        ASIN,
        Category,
        PROMOTION_IDS,
        SHIP_STATE,
        SUM(QTY) AS total_qty_sold,  -- Includes all statuses
        SUM(CASE WHEN STATUS = 'Shipped' THEN AMOUNT ELSE 0 END) AS shipped_revenue,  -- Revenue only from shipped orders
        SUM(CASE WHEN STATUS = 'Pending' THEN AMOUNT ELSE 0 END) AS potential_revenue,  -- Potential revenue from pending orders
        AVG(AMOUNT) AS avg_order_value,  -- Average of orders
        COUNT(CASE WHEN STATUS = 'Returned' THEN 1 ELSE NULL END) AS total_returns,
        COUNT(CASE WHEN STATUS = 'Cancelled' THEN 1 ELSE NULL END) AS total_cancellations
    FROM 
        {{ ref('stg_amazon_sales') }}
    WHERE
        STATUS IN ('Shipped', 'Returned', 'Cancelled', 'Pending')
    GROUP BY 
        ASIN, Category, PROMOTION_IDS, SHIP_STATE
)

SELECT
    ASIN,
    Category,
    PROMOTION_IDS,
    SHIP_STATE,
    total_qty_sold,
    shipped_revenue,
    potential_revenue,
    avg_order_value,
    total_returns,
    total_cancellations,
    total_returns / NULLIF(total_qty_sold, 0) * 100 AS return_rate,
    total_cancellations / NULLIF(total_qty_sold, 0) * 100 AS cancellation_rate
FROM 
    base_data