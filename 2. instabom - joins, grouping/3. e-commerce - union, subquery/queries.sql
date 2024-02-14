# ORDER **************************************************************************************************************
SELECT * FROM products ORDER BY price DESC;

SELECT * FROM products ORDER BY price ASC, weight;
# PAGING **************************************************************************************************************
SELECT * FROM products ORDER BY price OFFSET 5 LIMIT 5 ;
SELECT name FROM phones ORDER BY price DESC OFFSET 1 LIMIT 2;

# UNION **************************************************************************************************************

(SELECT * FROM products ORDER BY price DESC LIMIT 4) UNION
(SELECT price / weight as ration FROM products ORDER BY price / weight DESC LIMIT 4);

# UNION, UNION ALL, INTERSECT, INTERSECT ALL, EXCEPT, EXCEPT ALL

# SUBQUERY **************************************************************************************************************

# List the name and price of all products that are more expensive than all products in the Toys department

SELECT name, price FROM products WHERE price > (SELECT MAX(price) FROM products WHERE department = 'Toys');

# Subquery in SELECT (SCALAR ONLY)
SELECT name, price, (SELECT MAX(price) FROM products) FROM products WHERE price > 876;

# Subquery in FROM (ANY Subquery | MUST HAVE ALIAS | Looks like not full table but its filter state)

SELECT name, price_weight_ratio FROM (SELECT name, price / weight as price_weight_ratio FROM products) as p WHERE price_weight_ratio > 5; 

# Find the average number of orders for all users

SELECT user_id, (SELECT COUNT(*) FROM orders) / COUNT(*) as avg FROM orders GROUP BY user_id;
SELECT AVG(count) FROM (SELECT user_id, COUNT(*) FROM orders GROUP BY user_id) as p;

# Subquery in JOIN (any, same as for FROM)

SELECT * FROM users JOIN (SELECT user_id FROM orders WHERE product_id = 3) as p ON p.user_id = users.id;

# Subquery with WHERE (Scalar for comparison and Single Value for IN like operators)

SELECT * FROM orders WHERE product_id IN (SELECT id FROM products WHERE price / weight > 10);

# Show the name of all products that are not in the same department as products with a price less than 100
SELECT name FROM products WHERE department NOT IN (SELECT department FROM products WHERE price < 100);

# Show the name department and price of products that are more expensive than all products in the Industrial department

SELECT name, department, price FROM products WHERE price > (SELECT MAX(price) FROM products WHERE department = 'Industrial');
SELECT name, department, price FROM products WHERE price > SOME (SELECT price FROM products WHERE department = 'Industrial');

# Correlated subqueries

# Show name, department, price of the most expensive product in each department

SELECT name, department, price FROM products AS p1 WHERE price = (SELECT MAX(price) FROM products AS p2 WHERE p2.department = p1.department);

# Without using a join or group by print the number of orders for each product

SELECT name, (SELECT COUNT(*) FROM orders AS o WHERE p.id = o.product_id) FROM products as p;

# DISTINCT **************************************************************************************************************

SELECT DISTINCT department, name FROM products;

SELECT COUNT(DISTINCT department) FROM products;

# UTILITY OPERATORS **************************************************************************************************************

SELECT GREATEST (20, 10, 30); # 30
# Cost to ship 
SELECT name, weight, GREATEST(weight * 2, 30) as cost_to_ship FROM products;

SELECT LEAST (20, 10, 30); # 10

SELECT name, price, 
CASE 
  WHEN price > 600 THEN 'high'
  WHEN price > 300 THEN 'medium'
  ELSE 'cheap'
END
FROM products;

