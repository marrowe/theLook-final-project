--pull monthly trend data for sales/returns for two years (25 months)

WITH cte_date AS (
    SELECT 
        DATE(created_at) AS order_date,
        status,
        order_id,
        COUNT(*) OVER (PARTITION BY DATE(created_at)) AS total_daily_orders
    FROM 
        `bigquery-public-data.thelook_ecommerce.orders`
    WHERE 
        status IN ('Complete', 'Returned')
    ORDER BY 
        order_date, status
),
cte AS (
    SELECT 
        d.order_date,
        o.status,
        COUNT(DISTINCT d.order_id) AS cat_order_count,
        d.total_daily_orders,
        (COUNT(DISTINCT d.order_id) / d.total_daily_orders) AS order_pct,
        ROUND(SUM(oi.sale_price), 2) AS sale_price,
        COUNT(DISTINCT o.user_id) AS daily_customers
    FROM 
        `bigquery-public-data.thelook_ecommerce.orders` o
        LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi ON o.order_id = oi.order_id
        LEFT JOIN cte_date d ON d.order_id = o.order_id
    WHERE 
        o.status IN ('Complete', 'Returned')
    GROUP BY 
        order_date, 
        o.status, 
        d.total_daily_orders
    ORDER BY 
        order_date DESC
)

SELECT 
    status,
    DATE_TRUNC(order_date, MONTH) AS month,
    SUM(cat_order_count) AS monthly_cat_orders,
    SUM(total_daily_orders) AS monthly_total_orders,
    ROUND(SUM(cat_order_count) / SUM(total_daily_orders), 4) AS pct,
    SUM(daily_customers) AS monthly_customers,
    ROUND(SUM(sale_price), 2) AS monthly_sales
FROM 
    cte
WHERE 
    DATE(order_date) BETWEEN '2021-08-01' AND '2023-08-31'
GROUP BY 
    status, 
    month
ORDER BY 
    status DESC, 
    month DESC;
