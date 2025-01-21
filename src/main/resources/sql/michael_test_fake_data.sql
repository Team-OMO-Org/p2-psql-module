-- Insert fake customers
INSERT INTO customers (first_name, last_name, email, registered_at) VALUES
                                                                        ('John', 'Doe', 'john.doe@example.com', '2023-01-15'),
                                                                        ('Jane', 'Smith', 'jane.smith@example.com', '2023-02-20'),
                                                                        ('Alice', 'Johnson', 'alice.johnson@example.com', '2023-03-10'),
                                                                        ('Bob', 'Brown', 'bob.brown@example.com', '2023-04-05');

-- Insert fake categories
INSERT INTO categories (category_name, description) VALUES
                                                        ('Electronics', 'Devices and gadgets'),
                                                        ('Books', 'Fiction, non-fiction, and educational materials'),
                                                        ('Clothing', 'Men, women, and children apparel'),
                                                        ('Home Appliances', 'Kitchen and home equipment');

-- Insert fake products
INSERT INTO products (product_name, category_id, price, stock_quantity, created_at) VALUES
                                                                                        ('Smartphone', 1, 699.99, 50, '2023-01-10'),
                                                                                        ('Laptop', 1, 999.99, 30, '2023-01-15'),
                                                                                        ('Mystery Novel', 2, 14.99, 200, '2023-02-01'),
                                                                                        ('Cookbook', 2, 19.99, 150, '2023-02-05'),
                                                                                        ('T-Shirt', 3, 9.99, 100, '2023-03-01'),
                                                                                        ('Jeans', 3, 49.99, 75, '2023-03-10'),
                                                                                        ('Microwave Oven', 4, 89.99, 40, '2023-04-01'),
                                                                                        ('Blender', 4, 29.99, 60, '2023-04-10');

-- Insert fake orders
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
                                                                       (1, '2023-01-20', 'Shipped', 714.98),
                                                                       (2, '2023-02-25', 'Delivered', 19.99),
                                                                       (3, '2023-03-15', 'Cancelled', 0),
                                                                       (4, '2023-04-07', 'Pending', 139.98);

-- Insert fake order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                             (1, 1, 1), -- Smartphone
                                                             (1, 3, 1), -- Mystery Novel
                                                             (2, 4, 1), -- Cookbook
                                                             (4, 6, 2); -- Jeans (Pending order)

-- Insert fake shopping carts
INSERT INTO shopping_carts (customer_id, shopping_date) VALUES
                                                            (1, '2023-01-18'),
                                                            (2, '2023-02-22'),
                                                            (3, '2023-03-12'),
                                                            (4, '2023-04-05');

-- Insert fake shopping cart items
INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity) VALUES
                                                                             (1, 2, 1), -- Laptop
                                                                             (2, 5, 2), -- T-Shirt
                                                                             (3, 7, 1), -- Microwave Oven
                                                                             (4, 8, 3); -- Blender

-- 2nd Set of Fake Data
-- Insert new fake customers
INSERT INTO customers (first_name, last_name, email, registered_at) VALUES
                                                                        ('Emily', 'Taylor', 'emily.taylor@example.com', '2023-05-10'),
                                                                        ('Michael', 'Davis', 'michael.davis@example.com', '2023-06-15'),
                                                                        ('Sarah', 'Wilson', 'sarah.wilson@example.com', '2023-07-20'),
                                                                        ('James', 'Anderson', 'james.anderson@example.com', '2023-08-05');

-- Insert new fake categories
INSERT INTO categories (category_name, description) VALUES
                                                        ('Toys', 'Toys and games for children of all ages'),
                                                        ('Fitness', 'Exercise equipment and gear'),
                                                        ('Groceries', 'Everyday food and household items'),
                                                        ('Furniture', 'Home and office furniture');

-- Insert new fake products
INSERT INTO products (product_name, category_id, price, stock_quantity, created_at) VALUES
                                                                                        ('Action Figure', 1, 24.99, 150, '2023-06-01'),
                                                                                        ('Board Game', 1, 39.99, 80, '2023-06-10'),
                                                                                        ('Yoga Mat', 2, 19.99, 100, '2023-07-05'),
                                                                                        ('Dumbbells', 2, 49.99, 60, '2023-07-15'),
                                                                                        ('Organic Apples', 3, 3.99, 500, '2023-08-01'),
                                                                                        ('Milk', 3, 2.49, 300, '2023-08-05'),
                                                                                        ('Office Chair', 4, 129.99, 20, '2023-09-01'),
                                                                                        ('Dining Table', 4, 499.99, 10, '2023-09-10');

-- Insert new fake orders
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
                                                                       (1, '2023-05-15', 'Delivered', 64.98),
                                                                       (2, '2023-06-20', 'Shipped', 19.99),
                                                                       (3, '2023-07-25', 'Cancelled', 0),
                                                                       (4, '2023-08-10', 'Pending', 672.47);

-- Insert new fake order items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                             (1, 1, 1), -- Action Figure
                                                             (1, 2, 1), -- Board Game
                                                             (2, 3, 1), -- Yoga Mat
                                                             (4, 8, 1), -- Dining Table
                                                             (4, 7, 3); -- Office Chair

-- Insert new fake shopping carts
INSERT INTO shopping_carts (customer_id, shopping_date) VALUES
                                                            (1, '2023-05-12'),
                                                            (2, '2023-06-18'),
                                                            (3, '2023-07-22'),
                                                            (4, '2023-08-08');

-- Insert new fake shopping cart items
INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity) VALUES
                                                                             (1, 4, 1), -- Dumbbells
                                                                             (2, 5, 5), -- Organic Apples
                                                                             (3, 6, 2), -- Milk
                                                                             (4, 2, 1); -- Board Game

--
-- More Entries for customer_id=1
-- Insert new orders for customer_id=1
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
                                                                       (1, '2023-09-15', 'Delivered', 49.98),  -- Two products bought together
                                                                       (1, '2023-10-05', 'Pending', 149.99);  -- High-value pending order

-- Insert new order items for customer_id=1
INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                             (5, 3, 2), -- Yoga Mat
                                                             (5, 5, 5), -- Organic Apples
                                                             (6, 8, 1); -- Dining Table

-- Insert a new shopping cart for customer_id=1
INSERT INTO shopping_carts (customer_id, shopping_date) VALUES
    (1, '2023-10-02');

-- Insert new shopping cart items for customer_id=1
INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity) VALUES
                                                                             (5, 4, 2), -- Dumbbells
                                                                             (5, 7, 1); -- Office Chair

-- customer_id 1 more fake data
-- Insert new orders for customer_id=1
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
                                                                       (1, '2023-11-01', 'Shipped', 89.97),  -- Multiple small items in one order
                                                                       (1, '2023-11-15', 'Cancelled', 0);   -- Cancelled order with no total amount

-- Insert new order items for customer_id=1
INSERT INTO order_items (order_id, product_id, quantity) VALUES
                                                             (7, 1, 1), -- Action Figure
                                                             (7, 2, 1), -- Board Game
                                                             (7, 3, 1), -- Yoga Mat
                                                             (8, 6, 2); -- Milk (Cancelled order)

-- Insert a new shopping cart for customer_id=1
INSERT INTO shopping_carts (customer_id, shopping_date) VALUES
    (1, '2023-11-10');

-- Insert new shopping cart items for customer_id=1
INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity) VALUES
                                                                             (6, 5, 10), -- Organic Apples
                                                                             (6, 2, 1);  -- Board Game
