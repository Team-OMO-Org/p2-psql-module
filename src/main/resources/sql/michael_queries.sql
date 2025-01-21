-- All orders of a specific customer_id and their status
SELECT o.order_date, o.order_id, o.status, c.customer_id, c.last_name, c.first_name
FROM orders o
         JOIN order_items oi ON oi.order_id = o.order_id
         JOIN customers c ON c.customer_id = o.customer_id
-- WHERE c.first_name = 'John' AND c.last_name = 'Doe';
WHERE c.customer_id = 1
GROUP BY o.order_date, o.order_id, c.customer_id
ORDER BY o.order_date DESC;
-- ********************************************************************************************************************

-- most sold products top 3 with subquery, incl. more places with same amount of sales
SELECT SUM(oi.quantity) AS total_sold, oi.product_id, p.product_name
FROM order_items oi
         JOIN products p ON p.product_id = oi.product_id
GROUP BY oi.product_id, p.product_name
HAVING SUM(oi.quantity) IN (SELECT SUM(oi.quantity) AS total_sold
                            FROM order_items oi
                                     JOIN products p ON p.product_id = oi.product_id
                            GROUP BY oi.product_id, p.product_name
                            ORDER BY SUM(oi.quantity) DESC
                            LIMIT 3)
ORDER BY SUM(oi.quantity) DESC;
-- ********************************************************************************************************************

-- best earning categories top 3
SELECT SUM(p.price * oi.quantity) AS earnings, ca.category_id, ca.category_name
FROM order_items oi
         JOIN products p ON p.product_id = oi.product_id
         JOIN categories ca ON ca.category_id = p.category_id
GROUP BY ca.category_id, ca.category_id, ca.category_name
ORDER BY SUM(p.price * oi.quantity) DESC
LIMIT 3;
-- ********************************************************************************************************************

-- most valuable customer in terms of total money spent
SELECT SUM(p.price * oi.quantity) AS total_spent, c.customer_id, c.first_name, c.last_name
FROM order_items oi
         JOIN products p ON p.product_id = oi.product_id
         JOIN orders o ON o.order_id = oi.order_id
         JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY SUM(p.price * oi.quantity) DESC;
-- ********************************************************************************************************************