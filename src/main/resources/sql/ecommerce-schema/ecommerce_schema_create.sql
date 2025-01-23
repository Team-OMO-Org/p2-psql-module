--DROP DATABASE IF EXISTS omop2_db;
--CREATE DATABASE omop2_db;

DROP SCHEMA IF EXISTS ecommerce CASCADE;
CREATE SCHEMA ecommerce;
-- SET search_path TO ecommerce;

DROP TABLE IF EXISTS
    ecommerce.customers,
    ecommerce.categories,
    ecommerce.products,
    ecommerce.orders,
    ecommerce.order_items,
    ecommerce.shopping_carts,
    ecommerce.shopping_cart_items;

CREATE TABLE ecommerce.customers (
                                     customer_id SERIAL PRIMARY KEY,
                                     first_name VARCHAR(50) NOT NULL,
                                     last_name VARCHAR(50) NOT NULL,
                                     email VARCHAR(100) UNIQUE NOT NULL,
                                     registered_at DATE DEFAULT NOW()
);

CREATE TABLE ecommerce.categories (
                                      category_id SERIAL PRIMARY KEY,
                                      category_name VARCHAR(100) UNIQUE NOT NULL,
                                      description TEXT
);

CREATE TABLE ecommerce.products (
                                    product_id SERIAL PRIMARY KEY,
                                    product_name VARCHAR(100) NOT NULL,
                                    category_id INT REFERENCES ecommerce.categories(category_id) ON DELETE CASCADE,
                                    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
                                    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
                                    created_at DATE DEFAULT NOW()
);

CREATE TABLE ecommerce.orders (
                                  order_id SERIAL PRIMARY KEY,
                                  customer_id INT REFERENCES ecommerce.customers(customer_id) ON DELETE CASCADE,
                                  order_date DATE DEFAULT NOW(),
                                  status VARCHAR(50) DEFAULT 'Pending',
                                  total_amount DECIMAL(10, 2) DEFAULT 0 CHECK (total_amount >= 0),
                                  CONSTRAINT valid_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE ecommerce.order_items (
                                       order_item_id SERIAL PRIMARY KEY,
                                       order_id INT REFERENCES ecommerce.orders(order_id) ON DELETE CASCADE,
                                       product_id INT REFERENCES ecommerce.products (product_id) ON DELETE CASCADE,
                                       quantity INT NOT NULL
);

CREATE TABLE ecommerce.shopping_carts (
                                          shopping_cart_id  SERIAL PRIMARY KEY,
                                          customer_id INT REFERENCES ecommerce.customers(customer_id) ON DELETE CASCADE,
                                          shopping_date DATE DEFAULT NOW()
);

CREATE TABLE ecommerce.shopping_cart_items (
                                               shopping_cart_items_id  SERIAL PRIMARY KEY,
                                               shopping_cart_id INT REFERENCES ecommerce.shopping_carts(shopping_cart_id) ON DELETE CASCADE,
                                               product_id INT REFERENCES ecommerce.products(product_id) ON DELETE CASCADE,
                                               quantity INT NOT NULL
);