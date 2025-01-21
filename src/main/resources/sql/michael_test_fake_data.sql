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
