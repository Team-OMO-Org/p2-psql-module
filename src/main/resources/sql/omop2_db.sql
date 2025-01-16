--CREATE DATABASE omop2_db;

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
    order_date DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'Pending',
    total_amount DECIMAL(10, 2) DEFAULT 0 CHECK (total_amount >= 0),
    CONSTRAINT valid_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE shopping_carts (
	shoping_cart_id  SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
	shopping_date DATE DEFAULT NOW()
);

CREATE TABLE shopping_cart_items (
	shoping_cart_items_id  SERIAL PRIMARY KEY,
	shoping_cart_id INT REFERENCES shopping_carts(shoping_cart_id) ON DELETE CASCADE,
	product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
	quantity INT NOT NULL
);

