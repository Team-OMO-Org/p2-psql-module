INSERT INTO customers (first_name, last_name, email, registered_at)
VALUES
    ('Emma', 'Johnson', 'emma.johnson@example.com', '2020-02-15'),
    ('Liam', 'Smith', 'liam.smith@example.com', '2021-04-10'),
    ('Olivia', 'Brown', 'olivia.brown@example.com', '2020-12-05'),
    ('Noah', 'Williams', 'noah.williams@example.com', '2022-03-20'),
    ('Ava', 'Jones', 'ava.jones@example.com', '2023-01-10'),
    ('Sophia', 'Garcia', 'sophia.garcia@example.com', '2024-06-25'),
    ('Isabella', 'Martinez', 'isabella.martinez@example.com', '2022-11-12'),
    ('Mason', 'Davis', 'mason.davis@example.com', '2021-09-18'),
    ('Ethan', 'Lopez', 'ethan.lopez@example.com', '2020-08-30'),
    ('Mia', 'Wilson', 'mia.wilson@example.com', '2021-05-14'),
    ('James', 'Anderson', 'james.anderson@example.com', '2023-03-01'),
    ('Charlotte', 'Taylor', 'charlotte.taylor@example.com', '2024-02-22'),
    ('Amelia', 'Moore', 'amelia.moore@example.com', '2022-07-04'),
    ('Alexander', 'Thomas', 'alexander.thomas@example.com', '2020-10-27'),
    ('Harper', 'Martin', 'harper.martin@example.com', '2021-12-08'),
    ('Benjamin', 'Lee', 'benjamin.lee@example.com', '2020-06-21'),
    ('Evelyn', 'Perez', 'evelyn.perez@example.com', '2023-08-19'),
    ('Lucas', 'White', 'lucas.white@example.com', '2021-01-07'),
    ('Ella', 'Harris', 'ella.harris@example.com', '2020-03-25'),
    ('Michael', 'Clark', 'michael.clark@example.com', '2025-01-10'),
    ('Scarlett', 'Rodriguez', 'scarlett.rodriguez@example.com', '2022-05-10'),
    ('Jackson', 'Lewis', 'jackson.lewis@example.com', '2020-11-13'),
    ('Lily', 'Walker', 'lily.walker@example.com', '2021-07-28'),
    ('Aiden', 'Hall', 'aiden.hall@example.com', '2023-10-05'),
    ('Aria', 'Allen', 'aria.allen@example.com', '2024-01-19'),
    ('Henry', 'Young', 'henry.young@example.com', '2022-09-22'),
    ('Grace', 'King', 'grace.king@example.com', '2020-04-17'),
    ('Sebastian', 'Wright', 'sebastian.wright@example.com', '2021-11-30'),
    ('Chloe', 'Scott', 'chloe.scott@example.com', '2023-06-11'),
    ('Leo', 'Green', 'leo.green@example.com', '2020-01-03');



INSERT INTO categories (category_name, description)
VALUES
    ('Electronics', 'Devices, gadgets, and accessories for everyday use.'),
    ('Home Appliances', 'Essential appliances for modern households.'),
    ('Clothing', 'Men’s, women’s, and children’s apparel.'),
    ('Books', 'Fiction, non-fiction, and academic books.'),
    ('Beauty & Personal Care', 'Cosmetics, skincare, and grooming products.'),
    ('Sports & Outdoors', 'Gear and equipment for sports and outdoor activities.'),
    ('Toys & Games', 'Toys, board games, and puzzles for all ages.'),
    ('Furniture', 'Indoor and outdoor furniture for home and office.'),
    ('Groceries', 'Everyday food items and household essentials.'),
    ('Automotive', 'Car accessories, tools, and maintenance products.');

INSERT INTO products (product_name, category_id, price, stock_quantity, created_at)
VALUES
-- Electronics
('Samsung Galaxy S23', 1, 799.99, 50, '2019-07-15'),
('Apple MacBook Pro 15"', 1, 1999.99, 25, '2019-02-25'),
('Sony WH-1000XM5 Headphones', 1, 349.99, 40, '2019-05-20'),
('LG UltraGear 27" Gaming Monitor', 1, 299.99, 20, '2019-09-10'),
('Apple Watch Series 8', 1, 399.99, 30, '2019-03-08'),

-- Home Appliances
('Dyson V15 Detect Vacuum Cleaner', 2, 649.99, 15, '2019-01-12'),
('Samsung Wind-Free AC 1.5T', 2, 899.99, 10, '2019-06-28'),
('Panasonic 1000W Microwave Oven', 2, 129.99, 20, '2019-11-11'),
('LG TurboWash Washing Machine 7kg', 2, 599.99, 8, '2019-08-16'),
('Whirlpool Double Door Refrigerator 300L', 2, 749.99, 6, '2019-04-05'),

-- Clothing
('Nike Dri-FIT T-Shirt', 3, 24.99, 150, '2019-05-10'),
('Adidas Originals Women’s Dress', 3, 44.99, 100, '2019-03-12'),
('Champion Hoodie Unisex', 3, 49.99, 120, '2019-01-22'),
('Asics Gel Running Shoes', 3, 74.99, 90, '2019-10-18'),
('Columbia Winter Jacket', 3, 149.99, 40, '2019-07-02'),

-- Books
('Clean Code by Robert C. Martin', 4, 39.99, 70, '2019-09-19'),
('SQL in 10 Minutes by Ben Forta', 4, 19.99, 100, '2019-02-14'),
('JavaScript: The Good Parts by Douglas Crockford', 4, 34.99, 80, '2019-03-30'),
('Deep Learning with Python by François Chollet', 4, 59.99, 50, '2019-12-20'),
('Sapiens: A Brief History of Humankind by Yuval Noah Harari', 4, 19.99, 65, '2019-01-05'),

-- Beauty and Personal Care
('Neutrogena Hydro Boost Face Cream', 5, 25.99, 120, '2019-08-01'),
('Philips Hair Dryer 2100W', 5, 49.99, 80, '2019-05-19'),
('Gillette Fusion5 Shaving Kit', 5, 32.99, 100, '2019-11-03'),
('Real Techniques Makeup Brush Set', 5, 29.99, 110, '2019-02-27'),
('L’Oreal Paris Revitalift Serum', 5, 34.99, 150, '2019-06-21'),

-- Sports Equipment
('Manduka PRO Yoga Mat', 6, 129.99, 50, '2019-01-18'),
('Wilson Blade 98 Tennis Racket', 6, 179.99, 30, '2019-10-04'),
('Spalding NBA Basketball Size 7', 6, 29.99, 40, '2019-09-09'),
('CamelBak Chute Water Bottle', 6, 14.99, 120, '2019-07-15'),
('Garmin Forerunner 245 Fitness Watch', 6, 249.99, 30, '2019-04-22'),

-- Toys
('LEGO Star Wars Millennium Falcon', 7, 149.99, 40, '2019-03-14'),
('Hot Wheels Monster Trucks Set', 7, 34.99, 80, '2019-02-10'),
('Barbie Dreamhouse', 7, 179.99, 20, '2019-12-01'),
('Ty Beanie Baby Bear Plush Toy', 7, 9.99, 200, '2019-10-25'),
('Ravensburger 1000-Piece Puzzle', 7, 19.99, 90, '2019-01-17'),

-- Furniture
('IKEA Bekant Office Desk', 8, 229.99, 15, '2019-11-22'),
('Herman Miller Aeron Chair', 8, 1499.99, 5, '2019-03-30'),
('Wayfair 5-Tier Bookshelf', 8, 149.99, 10, '2019-05-05'),
('West Elm Dining Table Set', 8, 999.99, 5, '2019-02-09'),
('Zinus Memory Foam Queen Bed Frame', 8, 399.99, 7, '2019-08-15'),

-- Groceries
('Kirkland Organic Almonds (1kg)', 9, 14.99, 200, '2019-04-10'),
('Filippo Berio Olive Oil (1L)', 9, 11.99, 300, '2019-01-30'),
('Dave’s Killer Bread Whole Grain', 9, 5.49, 400, '2019-07-03'),
('Simply Orange Juice (1L)', 9, 4.99, 350, '2019-11-12'),
('Barilla Gluten-Free Spaghetti', 9, 3.99, 250, '2019-06-08'),

-- Health and Wellness
('Centrum Multivitamins', 10, 24.99, 100, '2019-02-01'),
('Optimum Nutrition Whey Protein', 10, 44.99, 120, '2019-05-15'),
('Sunbeam Electric Heating Pad', 10, 29.99, 40, '2019-09-25'),
('Braun No-Touch Thermometer', 10, 39.99, 80, '2019-12-18'),
('TheraBand Resistance Bands Set', 10, 19.99, 90, '2019-10-11');




--populate 400 orders

BEGIN;
DO $$
    DECLARE
        sh_c_id INT;
        cus_id INT;
        total DECIMAL(10,2);
        or_date DATE;
        or_id INT;
        last_date DATE;

    BEGIN

        FOR i IN 1..400 LOOP

        --choose randomly customer cus_id

        SELECT customer_id INTO cus_id FROM customers
        ORDER BY RANDOM()
        LIMIT 1;

        --last date for cus_id
        SELECT GREATEST((SELECT shopping_date FROM shopping_carts
                         WHERE customer_id = cus_id
                         ORDER BY shopping_date DESC
                         LIMIT 1), (SELECT registered_at FROM customers
                                    WHERE customer_id = cus_id)) INTO last_date;

        --create new shopping cart for cus_id after last date (0-39 days)

        INSERT INTO shopping_carts (customer_id, shopping_date)
        VALUES (cus_id, last_date + (RANDOM()*40)::INT)
        RETURNING shopping_cart_id INTO sh_c_id;


        --add 1-5 products with quantity 1-5 into shopping cart items
        FOR i IN 1..(RANDOM() * 5 + 1)::INT LOOP
                INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity)
                VALUES (sh_c_id,
                        (SELECT product_id FROM products
                         ORDER BY RANDOM()
                         LIMIT 1),
                        (RANDOM() * 5 + 1)::INT );
            END LOOP;


        -- row into orders

--or_date
        SELECT shopping_date + (RANDOM()*2):: INT  INTO or_date FROM shopping_carts
        WHERE shopping_cart_id = sh_c_id;


-- total
        SELECT SUM(shopping_cart_items.quantity * products.price) INTO total FROM shopping_cart_items
                                                                                      JOIN products ON shopping_cart_items.product_id = products.product_id
        WHERE shopping_cart_id = sh_c_id;



        INSERT INTO orders (customer_id, order_date, status, total_amount)
        VALUES  (cus_id,
                 or_date,
                 CASE
                     WHEN (RANDOM() * 3)::INT = 0 THEN 'Pending'
                     WHEN (RANDOM() * 3)::INT = 1 THEN 'Shipped'
                     ELSE 'Delivered'
                     END,
                 total)
        RETURNING order_id INTO or_id;

--order_items

        INSERT INTO order_items (order_id, product_id, quantity)
        SELECT or_id, products.product_id, shopping_cart_items.quantity FROM shopping_cart_items
                                                                                 JOIN products ON shopping_cart_items.product_id = products.product_id
        WHERE shopping_cart_id = sh_c_id
        GROUP BY shopping_cart_id, products.product_id, quantity;

            END LOOP;

    END $$;



COMMIT;


