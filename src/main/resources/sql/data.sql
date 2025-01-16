INSERT INTO customers (first_name, last_name, email, registered_at)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '2021-05-10'),
    ('Jane', 'Smith', 'jane.smith@example.com', '2020-08-15'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', '2019-12-01'),
    ('Bob', 'Brown', 'bob.brown@example.com', '2021-01-20'),
    ('Charlie', 'Davis', 'charlie.davis@example.com', '2022-07-22');


INSERT INTO categories (category_name, description)
VALUES
    ('Electronics', 'Devices, gadgets, and electronic products'),
    ('Clothing', 'Apparel and fashion items'),
    ('Home Appliances', 'Household appliances and tools'),
    ('Sports', 'Sporting goods and equipment'),
    ('Books', 'Physical and e-books'),
    ('Toys', 'Toys for children'),
    ('Health & Beauty', 'Beauty and personal care products'),
    ('Furniture', 'Furniture for home and office'),
    ('Food & Beverages', 'Groceries, drinks, and food products'),
    ('Automotive', 'Car parts, tools, and accessories');

INSERT INTO products (product_name, category_id, price, stock_quantity, created_at)
VALUES
    ('Laptop', 1, 999.99, 20, '2021-05-10'),
    ('Smartphone', 1, 499.99, 50, '2020-08-15'),
    ('Headphones', 1, 89.99, 100, '2019-12-01'),
    ('T-shirt', 2, 19.99, 150, '2021-01-20'),
    ('Jeans', 2, 49.99, 120, '2022-07-22'),
    ('Blender', 3, 99.99, 30, '2021-05-10'),
    ('Football', 4, 25.99, 80, '2020-08-15'),
    ('Basketball', 4, 29.99, 60, '2019-12-01'),
    ('Fiction Book', 5, 15.99, 200, '2021-01-20'),
    ('Action Figure', 6, 12.99, 150, '2022-07-22');

INSERT INTO orders (customer_id, order_date, status, total_amount)
VALUES
    (1, '2021-05-10', 'Shipped', 299.99),
    (2, '2020-08-15', 'Delivered', 549.49),
    (3, '2022-07-22', 'Pending', 89.99),
    (4, '2021-01-20', 'Shipped', 129.99),
    (5, '2020-12-01', 'Delivered', 499.99),
    (1, '2021-03-30', 'Shipped', 59.99),
    (2, '2022-01-12', 'Pending', 399.99),
    (3, '2021-11-05', 'Delivered', 249.49),
    (4, '2020-06-14', 'Pending', 79.99),
    (5, '2022-07-15', 'Shipped', 169.99),
    (1, '2021-07-25', 'Delivered', 99.99),
    (2, '2021-04-10', 'Shipped', 399.99),
    (3, '2020-09-03', 'Delivered', 129.99),
    (4, '2022-03-18', 'Shipped', 259.49),
    (5, '2021-05-10', 'Pending', 349.99),
    (1, '2022-02-28', 'Shipped', 149.99),
    (2, '2021-06-25', 'Delivered', 219.99),
    (3, '2020-11-17', 'Pending', 129.99),
    (4, '2021-10-20', 'Shipped', 99.99),
    (5, '2022-05-12', 'Shipped', 349.99),
    (1, '2021-04-02', 'Delivered', 499.99),
    (2, '2022-02-09', 'Shipped', 59.99),
    (3, '2021-03-18', 'Pending', 199.99),
    (4, '2020-07-22', 'Shipped', 149.99),
    (5, '2021-11-02', 'Shipped', 399.99),
    (1, '2021-09-05', 'Delivered', 229.99),
    (2, '2021-12-18', 'Pending', 89.99),
    (3, '2020-10-13', 'Shipped', 169.99),
    (4, '2022-01-05', 'Delivered', 279.99),
    (5, '2021-08-01', 'Shipped', 129.99),
    (1, '2021-10-19', 'Shipped', 59.99),
    (2, '2020-11-12', 'Delivered', 139.99),
    (3, '2021-05-30', 'Pending', 219.99),
    (4, '2022-04-11', 'Shipped', 399.99),
    (5, '2021-03-17', 'Delivered', 79.99),
    (1, '2020-12-22', 'Shipped', 89.99),
    (2, '2021-01-29', 'Delivered', 249.99),
    (3, '2022-06-14', 'Pending', 129.99),
    (4, '2020-05-23', 'Shipped', 169.99),
    (5, '2021-08-22', 'Shipped', 99.99),
    (1, '2021-08-10', 'Delivered', 49.99),
    (2, '2022-03-29', 'Shipped', 149.99),
    (3, '2020-06-08', 'Pending', 349.99),
    (4, '2021-09-27', 'Delivered', 159.99),
    (5, '2021-07-03', 'Shipped', 199.99),
    (1, '2022-04-01', 'Shipped', 199.99),
    (2, '2020-10-22', 'Delivered', 79.99),
    (3, '2021-04-30', 'Pending', 109.99),
    (4, '2022-05-16', 'Shipped', 239.99),
    (5, '2021-12-23', 'Shipped', 329.99),
    (1, '2021-02-11', 'Shipped', 249.99),
    (2, '2020-08-05', 'Delivered', 149.99);

INSERT INTO order_items (order_id, product_id, quantity)
VALUES
    (1, 1, 1),  -- Order 1: Laptop
    (1, 2, 2),  -- Order 1: Smartphone
    (2, 3, 1),  -- Order 2: Headphones
    (2, 4, 1),  -- Order 2: Mouse
    (3, 5, 1),  -- Order 3: Keyboard
    (4, 1, 1),  -- Order 4: Laptop
    (4, 2, 1),  -- Order 4: Smartphone
    (5, 3, 2),  -- Order 5: Headphones
    (6, 4, 3),  -- Order 6: Mouse
    (7, 5, 2),  -- Order 7: Keyboard
    (8, 1, 1),  -- Order 8: Laptop
    (9, 2, 2),  -- Order 9: Smartphone
    (10, 3, 1), -- Order 10: Headphones
    (11, 4, 2), -- Order 11: Mouse
    (12, 5, 3), -- Order 12: Keyboard
    (13, 1, 2), -- Order 13: Laptop
    (14, 2, 1), -- Order 14: Smartphone
    (15, 3, 2), -- Order 15: Headphones
    (16, 4, 1), -- Order 16: Mouse
    (17, 5, 1), -- Order 17: Keyboard
    (18, 1, 1), -- Order 18: Laptop
    (19, 2, 3), -- Order 19: Smartphone
    (20, 3, 1), -- Order 20: Headphones
    (21, 4, 3), -- Order 21: Mouse
    (22, 5, 2), -- Order 22: Keyboard
    (23, 1, 1), -- Order 23: Laptop
    (24, 2, 1), -- Order 24: Smartphone
    (25, 3, 3), -- Order 25: Headphones
    (26, 4, 2), -- Order 26: Mouse
    (27, 5, 1), -- Order 27: Keyboard
    (28, 1, 1), -- Order 28: Laptop
    (29, 2, 1), -- Order 29: Smartphone
    (30, 3, 1), -- Order 30: Headphones
    (31, 4, 2), -- Order 31: Mouse
    (32, 5, 2), -- Order 32: Keyboard
    (33, 1, 3), -- Order 33: Laptop
    (34, 2, 1), -- Order 34: Smartphone
    (35, 3, 2), -- Order 35: Headphones
    (36, 4, 1), -- Order 36: Mouse
    (37, 5, 2), -- Order 37: Keyboard
    (38, 1, 2), -- Order 38: Laptop
    (39, 2, 2), -- Order 39: Smartphone
    (40, 3, 1), -- Order 40: Headphones
    (41, 4, 1), -- Order 41: Mouse
    (42, 5, 3), -- Order 42: Keyboard
    (43, 1, 1), -- Order 43: Laptop
    (44, 2, 2), -- Order 44: Smartphone
    (45, 3, 2), -- Order 45: Headphones
    (46, 4, 1), -- Order 46: Mouse
    (47, 5, 2), -- Order 47: Keyboard
    (48, 1, 3), -- Order 48: Laptop
    (49, 2, 1), -- Order 49: Smartphone
    (50, 3, 2); -- Order 50: Headphones

INSERT INTO shopping_carts (customer_id, shopping_date)
VALUES
    (1, '2021-06-15'),
    (2, '2022-01-10'),
    (3, '2020-09-25'),
    (4, '2022-03-17'),
    (5, '2021-11-05');

INSERT INTO shopping_cart_items (shoping_cart_id, product_id, quantity)
VALUES
    (1, 1, 2), -- Cart 1: Laptop
    (1, 2, 1), -- Cart 1: Smartphone
    (2, 3, 1), -- Cart 2: Headphones
    (2, 4, 3), -- Cart 2: Mouse
    (3, 5, 2), -- Cart 3: Keyboard
    (4, 1, 1), -- Cart 4: Laptop
    (4, 2, 2), -- Cart 4: Smartphone
    (5, 3, 1), -- Cart 5: Headphones
    (5, 4, 3), -- Cart 5: Mouse
    (1, 3, 3), -- Cart 1: Headphones
    (2, 5, 2), -- Cart 2: Keyboard
    (3, 1, 1), -- Cart 3: Laptop
    (4, 2, 2), -- Cart 4: Smartphone
    (5, 5, 1), -- Cart 5: Keyboard
    (1, 4, 1), -- Cart 1: Mouse
    (2, 1, 2), -- Cart 2: Laptop
    (3, 2, 1), -- Cart 3: Smartphone
    (4, 3, 3), -- Cart 4: Headphones
    (5, 4, 2); -- Cart 5: Mouse
