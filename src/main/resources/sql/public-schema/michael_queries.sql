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

-- ToDo: following trigger
CREATE OR REPLACE FUNCTION update_total_amount()
    RETURNS TRIGGER AS $$
BEGIN
    -- Recalculate total_amount for the affected order
    UPDATE public.orders
    SET total_amount = (
        SELECT COALESCE(SUM(oi.quantity * p.price), 0)
        FROM public.order_items oi
                 JOIN public.products p ON oi.product_id = p.product_id
        WHERE oi.order_id = COALESCE(NEW.order_id, OLD.order_id)  -- Handle all cases
    )
    WHERE public.orders.order_id = COALESCE(NEW.order_id, OLD.order_id);

    RETURN NULL; -- No need to return a value for AFTER triggers
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER order_items_total_amount_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON public.order_items
    FOR EACH ROW
EXECUTE FUNCTION update_total_amount();

-- create new schema and gives right to user:
CREATE SCHEMA ecommerce;
GRANT USAGE ON SCHEMA ecommerce TO application_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ecommerce TO application_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA ecommerce GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO application_user;