-- pull returns by country

WITH cte AS (
    SELECT 
        o.user_id,
        o.status,
        u.country,
        COUNT(*) OVER (PARTITION BY country) AS total_from_country,
        DATE(o.shipped_at) AS shipped_at,
        DATE(o.returned_at) AS returned_at
    FROM 
        `bigquery-public-data.thelook_ecommerce.orders` o
        LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` u ON o.user_id = u.id
    WHERE 
        status IN ('Returned', 'Complete')
)

SELECT 
    status,
    country,
    COUNT(country) AS country_g,
    total_from_country,
    (COUNT(country) / total_from_country) AS pct
FROM 
    cte
WHERE 
    status IN ('Returned', 'Complete')
    AND (
        (shipped_at <= '2023-08-31' AND returned_at IS NULL)
        OR returned_at <= '2023-08-31'
    )
GROUP BY 
    country, 
    status, 
    total_from_country
HAVING 
    status = 'Returned'
ORDER BY 
    total_from_country DESC;
