-- calculate time between delivery and and return
 
WITH cleaned_category_products AS (
    SELECT 
        *,
        CASE 
            WHEN category = 'Suits' THEN 'Suits & Sport Coats'
            WHEN category = 'Socks' THEN 'Socks & Hosiery'
            WHEN category = 'Pants' THEN 'Pants & Capris'
            ELSE category
        END AS cleaned_category
    FROM 
        `bigquery-public-data.thelook_ecommerce.products`
),
total_orders AS (
    SELECT 
        p.cleaned_category,
        oi.status,
        DATE(oi.shipped_at) AS shipped,
        DATE(oi.delivered_at) AS delivered,
        DATE(oi.returned_at) AS returned,
        DATE_DIFF(DATE(oi.returned_at), DATE(oi.delivered_at), DAY) AS num_days,
        COUNT(*) OVER (PARTITION BY cleaned_category) AS category_count
    FROM 
        `bigquery-public-data.thelook_ecommerce.order_items` oi
        LEFT JOIN cleaned_category_products p ON p.id = oi.product_id
    WHERE 
        oi.status = 'Returned'
)

SELECT 
    num_days, 
    COUNT(status) AS total_returned_orders
FROM 
    total_orders
WHERE 
    category_count >= 100
    AND returned <= '2023-08-31'
GROUP BY 
    num_days
ORDER BY 
    num_days ASC;
