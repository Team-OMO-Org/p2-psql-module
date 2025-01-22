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
-- also index foreign keys, not done automatically in postgres

-- Customers Table
-- `email` is already indexed due to the UNIQUE constraint, no need for another index.
CREATE INDEX idx_customers_name ON customers(last_name, first_name);

-- Categories Table
-- `category_name` is already indexed due to the UNIQUE constraint, no additional index needed.

-- Products Table
-- Index for the foreign key `category_id` to speed up JOINs.
CREATE INDEX idx_products_category_id ON products (category_id);
CREATE INDEX idx_products_name_category ON products(product_name, category_id);

-- Orders Table
-- Index for the foreign key `customer_id` to speed up JOINs.
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- Index on `status` for filtering queries (e.g., WHERE status = 'Pending').
CREATE INDEX idx_orders_status ON orders (status);

CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- partial index, only index rows where status is 'Pending' or 'Shipped'
CREATE INDEX idx_orders_pending ON orders (order_date)
    WHERE status = 'Pending';

CREATE INDEX idx_orders_shipped ON orders (order_date)
    WHERE status = 'Shipped';


-- Order Items Table
-- Index for the foreign keys `order_id` and `product_id` to speed up JOINs.
CREATE INDEX idx_order_items_order_id ON order_items (order_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);

-- Combined index on `order_id` and `product_id` to optimize queries involving both.
CREATE INDEX idx_order_items_order_product ON order_items (order_id, product_id);

-- Shopping Carts Table
-- Index for the foreign key `customer_id` to speed up JOINs.
CREATE INDEX idx_shopping_carts_customer_id ON shopping_carts (customer_id);

-- Shopping Cart Items Table
-- Index for the foreign keys `shopping_cart_id` and `product_id` to speed up JOINs.
CREATE INDEX idx_shopping_cart_items_cart_id ON shopping_cart_items (shopping_cart_id);
CREATE INDEX idx_shopping_cart_items_product_id ON shopping_cart_items (product_id);

-- Combined index on `shopping_cart_id` and `product_id` for queries involving both.
CREATE INDEX idx_shopping_cart_items_cart_product ON shopping_cart_items (shopping_cart_id, product_id);

-- Additional Index Types
-- Gin Index on `description` in categories for full-text search queries.
CREATE INDEX idx_categories_description_gin ON categories USING gin (to_tsvector('english', description));

-- Brin Index on `registered_at` in customers for range queries on dates. clustered values
CREATE INDEX idx_customers_registered_at_brin ON customers USING brin (registered_at);

-- Btree Index on `price` in products for range queries (e.g., WHERE price BETWEEN x AND y).
CREATE INDEX idx_products_price_btree ON products (price);

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
