-- Create table with number of days between an order's creation/delivery, creation/return, and delivery/return.
-- Used to confirm that the synthetica ship times are often unrealistic and can't be analyzed as a reason for return
-- (e.g., item arrived too late).
SELECT 
    DATE(created_at) AS order_date,
    DATE(shipped_at) AS ship_date,
    DATE(delivered_at) AS deliver_date,
    DATE(returned_at) AS return_date,
    DATE_DIFF(DATE(delivered_at), DATE(created_at), day) AS order_to_delivery,
    DATE_DIFF(DATE(returned_at), DATE(created_at), day) AS order_to_return,
    DATE_DIFF(DATE(returned_at), DATE(delivered_at), day) AS delivery_to_return

FROM 
    `bigquery-public-data.thelook_ecommerce.orders`

WHERE 
    status IN ('Delivered', "Returned")