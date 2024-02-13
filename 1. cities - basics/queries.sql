

# CRUD **************************************************************************************************************

# Inserting
INSERT INTO cities (name, country, population, area) VALUES ('Tokyo', 'Japan', 38505000, 8233);

INSERT INTO cities (name, country, population, area) VALUES 
  ('Delhi', 'India', 28125000, 2240),
  ('Shanghai', 'China', 22125000, 4015),
  ('Sao Paulo', 'Brazil', 20935000, 3043);

# SELECTS 
SELECT * FROM cities;
# OPERATIONS
SELECT name, (population / area) as density FROM cities;
SELECT name || ', ' || country as location FROM cities;
SELECT CONCAT(name, ', ', country) as location FROM cities;
SELECT UPPER(name) as location FROM cities;
SELECT LENGTH(name) as location FROM cities;

# WHERE
SELECT * FROM cities WHERE area > 4000;
SELECT * FROM cities WHERE area BETWEEN 2000 and 4000;
SELECT * FROM cities WHERE name IN ('Delhi', 'Tokyo');
SELECT population / area as density FROM cities WHERE population / area  > 5000;

# UPDATE

UPDATE cities SET population=39505000 WHERE name = 'Tokyo';

# DELETE 

DELETE FROM cities WHERE name = 'Tokyo';