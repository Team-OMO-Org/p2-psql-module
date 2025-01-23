CREATE USER new_user WITH PASSWORD 'password';

REVOKE ALL ON SCHEMA public FROM public;

GRANT USAGE ON SCHEMA public TO new_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO new_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO new_user;

DO
$$
    DECLARE
        seq_record RECORD;
    BEGIN
        -- Loop through all sequences in the 'public' schema
        FOR seq_record IN
            SELECT sequence_schema, sequence_name
            FROM information_schema.sequences
            WHERE sequence_schema = 'public'
            LOOP
                -- Dynamically execute GRANT command
                EXECUTE 'GRANT USAGE, SELECT ON SEQUENCE ' || seq_record.sequence_schema || '.' ||
                        seq_record.sequence_name || ' TO new_user';
            END LOOP;
    END
$$;
