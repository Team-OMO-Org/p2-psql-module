-- 1. Connect to PostgreSQL as a superuser (e.g., postgres)
-- This step is typically done through the psql command-line interface
-- You can also use a PostgreSQL client tool (e.g., pgAdmin, DBeaver)

-- 2. Create a new user (replace 'new_user' and 'password' with your desired username and password)
CREATE USER new_user WITH PASSWORD 'password';

-- 3. Grant all privileges on the specific database (omop2_db)
GRANT ALL PRIVILEGES ON DATABASE omop2_db TO new_user;

-- 4. (Optional) Grant the user the ability to create schemas, tables, and other objects
\c omop2_db;  -- Connect to the omop2_db database
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO new_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO new_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO new_user;

-- 5. Ensure that the user has future privileges on new objects created in the public schema
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO new_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO new_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO new_user;
