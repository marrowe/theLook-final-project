-- pull data on returns by product category
-- includes number/% of returns/total product as well as item cost, sale price, and margin

WITH cleaned_category_products AS (
    SELECT 
        *,
        CASE 
            WHEN category = 'Suits' THEN 'Suits & Sport Coats'
            WHEN category = 'Socks' THEN 'Socks & Hosiery'
            WHEN category = 'Pants' THEN 'Pants & Capris'
            ELSE category
        END AS cleaned_category
    FROM `bigquery-public-data.thelook_ecommerce.products`
),
total_orders AS (
    SELECT 
        p.cleaned_category,
        o.status,
        p.cost,
        p.retail_price,
        p.retail_price - p.cost AS profit_margin,
        COUNT(*) OVER (PARTITION BY cleaned_category) AS category_count
    FROM `bigquery-public-data.thelook_ecommerce.order_items` o
    LEFT JOIN cleaned_category_products p ON p.id = o.product_id
    WHERE 
        o.status IN ('Complete', 'Returned')
        AND (
            (o.shipped_at <= '2023-08-31' AND o.returned_at IS NULL)
            OR o.returned_at <= '2023-08-31'
        )
)

SELECT 
    cleaned_category,
    status,
    COUNT(*) AS category_status_count,
    category_count,
    ROUND(COUNT(*) / category_count, 4) AS pct,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(retail_price), 2) AS total_price,
    ROUND(SUM(profit_margin), 2) AS total_margin
FROM 
    total_orders
WHERE 
    category_count >= 100
GROUP BY 
    cleaned_category, 
    status, 
    category_count
HAVING 
    status = 'Returned'
ORDER BY 
    pct DESC;
