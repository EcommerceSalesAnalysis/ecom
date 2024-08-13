{{ config(
    materialized='table'  
) }}

SELECT
    ASIN,
    Category,
    CASE WHEN PROMOTION_IDS IS NOT NULL THEN 'Promotion Applied' ELSE 'No Promotion' END AS promotion_type,
    SUM(QTY) AS total_qty_sold,
    SUM(AMOUNT) AS total_revenue,
    AVG(AMOUNT) AS avg_order_value
FROM
    {{ ref('stg_amazon_sales') }}
WHERE
    STATUS = 'Shipped'
GROUP BY
    ASIN, Category, promotion_type
ORDER BY 
    ASIN