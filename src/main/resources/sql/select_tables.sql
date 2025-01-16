-- Retrieve all records from the customers table
SELECT * FROM customers;

-- Retrieve all records from the categories table
SELECT * FROM categories;

-- Retrieve all records from the products table
SELECT * FROM products;

-- Retrieve all records from the orders table
SELECT * FROM orders;

-- Retrieve all records from the shopping_carts table
SELECT * FROM shopping_carts;

-- Retrieve all records from the shopping_cart_items table
SELECT * FROM shopping_cart_items;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.registered_at,
    sc.shoping_cart_id,
    sc.shopping_date,
    sci.shoping_cart_items_id,
    sci.product_id,
    sci.quantity,
    p.product_name,
    p.price,
    p.stock_quantity,
    p.created_at AS product_created_at,
    cat.category_name,
    cat.description AS category_description,
    o.order_id,
    o.order_date,
    o.status AS order_status,
    o.total_amount
FROM
    customers c
        LEFT JOIN shopping_carts sc ON c.customer_id = sc.customer_id
        LEFT JOIN shopping_cart_items sci ON sc.shoping_cart_id = sci.shoping_cart_id
        LEFT JOIN products p ON sci.product_id = p.product_id
        LEFT JOIN categories cat ON p.category_id = cat.category_id
        LEFT JOIN orders o ON c.customer_id = o.customer_id;
