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



        INSERT INTO orders (customer_id, order_date, total_amount)
        VALUES  (cus_id,
                 or_date,
                 total)
        RETURNING order_id INTO or_id;

--order_items

        INSERT INTO order_items (order_id, product_id, quantity)
        SELECT or_id, products.product_id, shopping_cart_items.quantity FROM shopping_cart_items
                                                                                 JOIN products ON shopping_cart_items.product_id = products.product_id
        WHERE shopping_cart_id = sh_c_id
        GROUP BY shopping_cart_id, products.product_id, quantity;


        UPDATE products
        SET stock_quantity = stock_quantity - (SELECT SUM(quantity)
                                               FROM order_items
                                               WHERE order_id = or_id
                                                 AND products.product_id = order_items.product_id)
        WHERE products.product_id IN (SELECT product_id
                                      FROM order_items
                                      WHERE order_id = or_id);

        IF EXISTS (
            SELECT 1
            FROM products
            WHERE stock_quantity < 0
        ) THEN
            ROLLBACK;
            -- RAISE EXCEPTION 'Stock quantity cannot be negative. Transaction rolled back.';

        END IF;

    END $$;

COMMIT;



--example of rollback, because stock < quantity of products in order
-- product id = 1, quantity = 75

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


        --add product id = 1 with quantity 75 into shopping cart items

                INSERT INTO shopping_cart_items (shopping_cart_id, product_id, quantity)
                VALUES (sh_c_id,1,75 );


        -- row into orders

--or_date
        SELECT shopping_date + (RANDOM()*2):: INT  INTO or_date FROM shopping_carts
        WHERE shopping_cart_id = sh_c_id;


-- total
        SELECT SUM(shopping_cart_items.quantity * products.price) INTO total FROM shopping_cart_items
                                                                                      JOIN products ON shopping_cart_items.product_id = products.product_id
        WHERE shopping_cart_id = sh_c_id;



        INSERT INTO orders (customer_id, order_date, total_amount)
        VALUES  (cus_id,
                 or_date,
                 total)
        RETURNING order_id INTO or_id;

--order_items

        INSERT INTO order_items (order_id, product_id, quantity)
        SELECT or_id, products.product_id, shopping_cart_items.quantity FROM shopping_cart_items
                                                                                 JOIN products ON shopping_cart_items.product_id = products.product_id
        WHERE shopping_cart_id = sh_c_id
        GROUP BY shopping_cart_id, products.product_id, quantity;


        UPDATE products
        SET stock_quantity = stock_quantity - ( SELECT SUM(quantity)
                                                FROM order_items
                                                WHERE order_id = or_id
                                                  AND products.product_id = order_items.product_id)
        WHERE products.product_id IN (SELECT product_id
                                      FROM order_items
                                      WHERE order_id = or_id);

        IF EXISTS (
            SELECT 1
            FROM products
            WHERE stock_quantity < 0
        ) THEN
            ROLLBACK;
            -- RAISE EXCEPTION 'Stock quantity cannot be negative. Transaction rolled back.';

        END IF;

    END $$;

COMMIT;



