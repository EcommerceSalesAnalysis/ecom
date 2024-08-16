{{ config(
    materialized='table'  
) }}

SELECT
    ASIN,
    Category,
    CASE WHEN PROMOTION_IDS IS NOT NULL THEN 'Promotion Applied' ELSE 'No Promotion' END AS promotion_type,
    SUM(total_qty_sold) AS total_qty_sold,
    SUM(shipped_revenue) AS total_revenue,
    AVG(avg_order_value) AS avg_order_value
FROM
    {{ ref('int_sales_summary') }}
GROUP BY
    ASIN, Category, promotion_type
ORDER BY 
    ASIN, promotion_type