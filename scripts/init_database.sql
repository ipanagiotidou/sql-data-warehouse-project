/*
=============================================================
init_database.sql
=============================================================
Purpose:
    Initialize the PostgreSQL environment for the Data Warehouse course.
    This script:
    1. Drops the 'datawarehouse' database if it exists
    2. Creates a new 'datawarehouse' database
    3. Connects to the new database
    4. Creates three schemas: bronze, silver, gold

WARNING:
    Running this script will permanently delete all data in
    the 'datawarehouse' database if it exists.
=============================================================
*/

-- ===============================================
-- Step 1: Terminate connections to the database
-- ===============================================
DO
$$
BEGIN
   IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'datawarehouse') THEN
       PERFORM pg_terminate_backend(pid)
       FROM pg_stat_activity
       WHERE datname = 'datawarehouse'
         AND pid <> pg_backend_pid();
   END IF;
END
$$;

-- ===============================================
-- Step 2: Drop database if it exists
-- ===============================================
DROP DATABASE IF EXISTS datawarehouse;

-- ===============================================
-- Step 3: Create the database
-- ===============================================
CREATE DATABASE datawarehouse;

-- ===============================================
-- Step 4: Connect to the new database
-- NOTE: This works only in psql, not pgAdmin Query Tool
-- If using pgAdmin, open a new Query Tool connected to 'datawarehouse'
-- ===============================================
\c datawarehouse

-- ===============================================
-- Step 5: Create schemas
-- ===============================================
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- ===============================================
-- Step 6: Optional: Set search path (nice for DWH)
-- ===============================================
ALTER DATABASE datawarehouse
SET search_path = bronze, silver, gold, public;

-- Script complete

