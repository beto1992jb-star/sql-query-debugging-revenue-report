-- Revenue report by city: delivered orders placed in 2026, cities above 10,000,000
SELECT c.city,
       COUNT(DISTINCT o.order_id) AS orders, -- FIXED: added DISTINCT to prevent duplicate order counts across multiple order_items rows
       COUNT(DISTINCT c.customer_id) AS customers, -- FIXED: added DISTINCT to avoid inflating customer counts per city due to order_items join
       SUM(i.quantity * i.unit_price) AS revenue
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN order_items i ON i.order_id = o.order_id -- FIXED: joined on o.order_id instead of o.customer_id to match line items to their actual order
WHERE o.status = 'delivered' AND o.order_date >= '2026-01-01' -- FIXED: used >= instead of > so delivered orders placed on 2026-01-01 are included
GROUP BY c.city -- FIXED: grouped by c.city instead of c.customer_id to aggregate metrics per city
HAVING SUM(i.quantity * i.unit_price) > 10000000 -- FIXED: moved aggregate revenue filter from WHERE to HAVING after GROUP BY
ORDER BY revenue DESC;