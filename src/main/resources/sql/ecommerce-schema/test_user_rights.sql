select *
from ecommerce.customers
order by customer_id
limit 10;

INSERT INTO ecommerce.customers (first_name, last_name, email, registered_at)
VALUES
    ('John3', 'Emma', 'ja3.johnson@example.com', '2020-02-15');

select *
from ecommerce.customers
order by customer_id DESC
limit 10;

update ecommerce.customers
set first_name = 'John'
where customer_id = 2;

delete
from ecommerce.customers
where customer_id = 2;

create table ecommerce.new_table
(
);
create table public.new_table
(
);
drop table ecommerce.customers;