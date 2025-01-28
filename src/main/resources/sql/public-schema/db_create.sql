--DROP DATABASE IF EXISTS omop2_db;
--CREATE DATABASE omop2_db;

DROP TABLE IF EXISTS customers, categories, products, orders, order_items, shopping_carts, shopping_cart_items CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registered_at DATE DEFAULT NOW()
);

 CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id) ON DELETE CASCADE,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    created_at DATE DEFAULT NOW()
 );

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date DATE DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) DEFAULT 0 CHECK (total_amount >= 0),
    CONSTRAINT valid_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products (product_id) ON DELETE CASCADE,
    quantity INT NOT NULL
);

CREATE TABLE shopping_carts (
    shopping_cart_id  SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    shopping_date DATE DEFAULT NOW()
);

CREATE TABLE shopping_cart_items (
     shopping_cart_items_id  SERIAL PRIMARY KEY,
     shopping_cart_id INT REFERENCES shopping_carts(shopping_cart_id) ON DELETE CASCADE,
     product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
     quantity INT NOT NULL
);

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

-- 21. CREATE VIEW order_details
CREATE VIEW order_details AS
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.product_name,
    oi.quantity,
    (oi.quantity * p.price) AS line_total,
    o.total_amount AS order_total
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
        JOIN
    order_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id;

-- Create the trigger trigger_prevent_category_deletion
CREATE OR REPLACE FUNCTION prevent_category_deletion() RETURNS TRIGGER AS $$
BEGIN
    -- Check if there are any products associated with the category to be deleted
    IF EXISTS (SELECT 1 FROM products WHERE category_id = OLD.category_id) THEN
        -- Raise an exception if there are products associated with the category
        RAISE EXCEPTION 'Cannot delete category % as it is still associated with products', OLD.category_id;
    END IF;

    -- Return OLD to proceed with the deletion
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the categories table
CREATE TRIGGER trigger_prevent_category_deletion
    BEFORE DELETE ON categories
    FOR EACH ROW
EXECUTE FUNCTION prevent_category_deletion();
