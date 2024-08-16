{{ config(
    materialized='table'  
) }}

WITH 
cancellation_revenue AS (
    SELECT
        ASIN,
        SUM(shipped_revenue) AS revenue_loss_due_to_cancellations
    FROM
        {{ ref('int_sales_summary') }}
    WHERE
        total_cancellations > 0
    GROUP BY
        ASIN
),

return_revenue AS (
    SELECT
        ASIN,
        SUM(shipped_revenue) AS revenue_loss_due_to_returns
    FROM
        {{ ref('int_sales_summary') }}
    WHERE
        total_returns > 0
    GROUP BY
        ASIN    
)

SELECT
    ps.ASIN,
    ps.Category,
    SUM(ps.total_qty_sold) AS total_qty_sold,  -- Total quantity sold across all statuses
    SUM(ps.shipped_revenue) AS total_revenue,  -- Total revenue from shipped orders
    AVG(ps.avg_order_value) AS avg_order_value,  -- Average order value from shipped orders
    SUM(ps.total_returns) AS total_returns,  -- Total returns
    SUM(ps.total_cancellations) AS total_cancellations,  -- Total cancellations
    SUM(ps.total_returns) / NULLIF(SUM(ps.total_qty_sold), 0) * 100 AS return_rate,  -- Return rate as a percentage
    SUM(ps.total_cancellations) / NULLIF(SUM(ps.total_qty_sold), 0) * 100 AS cancellation_rate,  -- Cancellation rate as a percentage
    COALESCE(cr.revenue_loss_due_to_cancellations, 0) AS revenue_loss_due_to_cancellations,  -- Revenue loss due to cancellations
    COALESCE(rr.revenue_loss_due_to_returns, 0) AS revenue_loss_due_to_returns  -- Revenue loss due to returns
FROM
    {{ ref('int_sales_summary') }} ps
LEFT JOIN
    cancellation_revenue cr ON ps.ASIN = cr.ASIN
LEFT JOIN
    return_revenue rr ON ps.ASIN = rr.ASIN
GROUP BY
    ps.ASIN, ps.Category, cr.revenue_loss_due_to_cancellations, rr.revenue_loss_due_to_returns
