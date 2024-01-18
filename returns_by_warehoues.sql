-- Compare return rate by distribution center

WITH cte AS (
    SELECT 
        dc.name,
        oi.status,
        COUNT(oi.id) AS products
    FROM 
        `bigquery-public-data.thelook_ecommerce.order_items` oi
        LEFT JOIN `bigquery-public-data.thelook_ecommerce.inventory_items` ii ON oi.id = ii.id
        LEFT JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` dc ON ii.product_distribution_center_id = dc.id
    WHERE 
        oi.status IN ('Complete', 'Returned')
    GROUP BY 
        dc.name, oi.status
)

SELECT 
    *, 
    SUM(products) OVER (PARTITION BY name) AS total,
    round((products / SUM(products) OVER (PARTITION BY name), 4) AS pct
FROM 
    cte
WHERE 
    status IN ('Returned', 'Complete')
GROUP BY 
    name, status, products
QUALIFY 
    status = 'Returned'  -- make it easier to read by dropping Completes
ORDER BY 
    pct DESC;
