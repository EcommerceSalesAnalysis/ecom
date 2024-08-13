{{ config(
    materialized='table'  
) }}

-- IF COURIER_STATUS = ‘Cancelled’ change STATUS to ‘Cancelled’
-- Change ‘Shipped-Delivered to buyer’ in status column to ‘Shipped’
-- Change ‘Shipped - Returned to Seller’ to ‘Returned’
-- Change ‘Shipped - Returning to Seller’ to ‘Returned’
-- Change ‘Shipped - Out for Delivery’  to ‘Shipped’
-- Drop all that say ‘Shipped - Damaged’ or ‘Shipped - Lost in Transit’ or ‘Shipped - Rejected by Buyer’
-- Change ‘Shipping’ to Shipped
-- Fix nulls in amount by using subqueries (And If we cant find an amount to use from other orders of the same product then remove that product)
-- DROP all columns not being used by the bi questions (keep COURIER_STATUS for staging)


{{ config(
    materialized='table'  
) }}

WITH amount_cleaned AS (
    SELECT 
        SKU,
        Category,
        Qty,
        FIRST_VALUE(AMOUNT) OVER (PARTITION BY SKU ORDER BY CASE WHEN AMOUNT IS NOT NULL THEN 1 ELSE 0 END DESC) AS AMOUNT_CLEANED,
        STATUS,
        Fulfilment,
        Date,
        SHIP_STATE,
        COURIER_STATUS
    FROM 
        {{ source('google_sheets', 'AMAZON_SALES') }} a
),

status_cleaned AS (
    SELECT
        SKU,
        Category,
        Qty,
        AMOUNT_CLEANED,
        CASE
            WHEN COURIER_STATUS = 'Cancelled' THEN 'Cancelled'
            WHEN STATUS = 'Shipped - Delivered to buyer' THEN 'Shipped'
            WHEN STATUS IN ('Shipped - Returned to Seller', 'Shipped - Returning to Seller') THEN 'Returned'
            WHEN STATUS = 'Shipped - Out for Delivery' THEN 'Shipped'
            WHEN STATUS = 'Shipping' THEN 'Shipped'
            ELSE STATUS
        END AS STATUS_CLEANED,
        Fulfilment,
        Date,
        SHIP_STATE,
        COURIER_STATUS
    FROM
        amount_cleaned
    WHERE
        STATUS NOT IN ('Shipped - Damaged', 'Shipped - Lost in Transit', 'Shipped - Rejected by Buyer')
)

SELECT 
    SKU,
    Category,
    Qty,
    AMOUNT_CLEANED AS AMOUNT,
    STATUS_CLEANED AS STATUS,
    Fulfilment,
    Date,
    SHIP_STATE,
    COURIER_STATUS
FROM 
    status_cleaned
WHERE 
    AMOUNT_CLEANED IS NOT NULL
    AND AMOUNT_CLEANED > 0
