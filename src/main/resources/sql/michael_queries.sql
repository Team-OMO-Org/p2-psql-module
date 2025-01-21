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

-- add index for often searched columns to speed up the process
-- focus on frequently used fields in WHERE, JOIN, and GROUP BY clauses

-- customers table
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_name ON customers(last_name, first_name);

-- products table
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_name_category ON products(product_name, category_id);

-- orders table
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- order_items table
-- ...
-- ********************************************************************************************************************

-- ToDo: following trigger
CREATE TRIGGER order_items_total_amount_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON order_items
    FOR EACH ROW
EXECUTE FUNCTION update_total_amount();

--
CREATE OR REPLACE FUNCTION update_total_amount()
    RETURNS TRIGGER AS $$
BEGIN
    -- Recalculate total_amount for the order
    UPDATE orders
    SET total_amount = (
        SELECT COALESCE(SUM(oi.quantity * p.price), 0)
        FROM order_items oi
        JOIN public.products p on oi.product_id = p.product_id
        WHERE oi.order_id = NEW.order_id
    )
    WHERE orders.order_id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


