CREATE USER new_user3 WITH PASSWORD 'password';

GRANT USAGE ON SCHEMA ecommerce TO new_user3;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ecommerce TO new_user3;
ALTER DEFAULT PRIVILEGES IN SCHEMA ecommerce GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO new_user3;
-- GRANT USAGE, SELECT ON SEQUENCE ecommerce.customers_customer_id_seq TO new_user3;

DO
$$
    DECLARE
        seq_record RECORD;
    BEGIN
        -- Loop through all sequences in the 'ecommerce' schema
        FOR seq_record IN
            SELECT sequence_schema, sequence_name
            FROM information_schema.sequences
            WHERE sequence_schema = 'ecommerce'
            LOOP
                -- Dynamically execute GRANT command
                EXECUTE 'GRANT USAGE, SELECT ON SEQUENCE ' || seq_record.sequence_schema || '.' ||
                        seq_record.sequence_name || ' TO new_user3';
            END LOOP;
    END
$$;
