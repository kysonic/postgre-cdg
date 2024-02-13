# ROW LEVEL VALIDATION 
# 1. IS DEFINED ? 
# 2. IS UNIQUE  ? 
# 3. OPERATORS >=, <= ...

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR,
  department VARCHAR,
  price INTEGER,
  weight INTEGER
);
# NOT NULL | REQUIRED 
ALTER TABLE products
ALTER COLUMN price 
SET NOT NULL;

# DEFAULT
ALTER TABLE products
ALTER COLUMN price 
SET DEFAULT 999;

# UNIQUE
ALTER TABLE products
ADD UNIQUE(name);

# MULTIPLE UNIQUE
ALTER TABLE products
ADD UNIQUE(name, department); # Only combination of these must be unique

# REMOVE CONSTRAINT 
ALTER TABLE products
DROP CONSTRAINT products_name_key; # name is created by template but it is better to check PG Admin for that

# COMPARISON VALIDATION
ALTER TABLE products
ADD CHECK(price > 0);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  est_delivery TIMESTAMP NOT NULL,
  CHECK (created_at < est_delivery)
);

ALTER TABLE orders 
ADD CHECK (created_at < est_delivery);

# ////////////////////
CREATE TABLE products (
  ... 
  name VARCHAR UNIQUE,
  price INTEGER NOT NULL DEFAULT 999 CHECK(price > 0),
  ...
);