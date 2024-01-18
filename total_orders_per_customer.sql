-- calculate number of orders per customer and share within complete vs. return

with orders_with_ids AS (
    SELECT 
        order_id,
        user_id, 
        created_at,
        status,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at ASC) AS order_seq,
        COUNT(order_id) OVER (PARTITION BY user_id) AS total_orders
    FROM 
        `bigquery-public-data.thelook_ecommerce.orders` 
    WHERE 
        status IN ('Complete', 'Returned')
        AND (
            (returned_at <= "2023-08-31" AND status = 'Returned')
            OR (delivered_at <= "2023-08-31" AND status = 'Complete')
            )
    GROUP BY 
        order_id, user_id, created_at, status
    ORDER BY user_id
),

grouped AS (
    SELECT 
        status,
        user_id,
        MAX(order_seq) AS final_order
    FROM 
        orders_with_ids
    GROUP BY 
        user_id, status
),
summed as (
    select 
        status,
        count(*) as ct
    from 
        grouped
    GROUP BY
        status
),
agged as (
    SELECT
        status, 
        final_order,
        COUNT(final_order) AS order_totals
    FROM 
        grouped
    GROUP BY 
        status, final_order
    ORDER BY 
        final_order
)

SELECT 
    agged.status, 
    final_order,
    order_totals,
    ROUND(order_totals/summed.ct, 3) as prop,
FROM 
    agged --summed
LEFT JOIN summed
    ON agged.status = summed.status
ORDER BY 
    agged.status, final_order
