# Show username and how many likes they have

SELECT username, COUNT(*) FROM likes JOIN users ON users.id = likes.user_id GROUP BY username ORDER BY COUNT(*) DESC;


# Indexes analyzing 
EXPLAIN ANALYZE SELECT COUNT(*) FROM likes WHERE created_at < '2013-01-01'; # PG uses index because it knows that estimation is lower than seq search
EXPLAIN ANALYZE SELECT COUNT(*) FROM likes WHERE created_at > '2013-01-01'; # PG seq search because it knows that estimation is lower than index (random nodes cost items * 4)


# Show the username of users who where tagged in a caption or photo before January 7th 2010. Also show a date they where tagged

(SELECT username FROM photo_tags JOIN users ON users.id = photo_tags.user_id WHERE photo_tags.created_at < '07-01-2010')
UNION
(SELECT username FROM caption_tags JOIN users ON users.id = caption_tags.user_id WHERE caption_tags.created_at < '07-01-2010')

SELECT username FROM users JOIN (
	SELECT user_id, created_at FROM caption_tags
	UNION ALL
	SELECT user_id, created_at FROM photo_tags
) as tags ON users.id = tags.user_id;

# Using Common Table Expressions 
WITH tags AS (
	SELECT user_id, created_at FROM caption_tags
	UNION ALL
	SELECT user_id, created_at FROM photo_tags
)
SELECT username FROM users JOIN tags ON users.id = tags.user_id;

# Recursive CTE

WITH RECURSIVE countdown(val) AS (
  SELECT 3 AS val
  UNION 
  SELECT val - 1 FROM countdown WHERE val > 1
)
SELECT * FROM countdown;

# Find followers suggestions 

WITH RECURSIVE suggestions(leader_id, follower_id, depth) AS (
	SELECT leader_id, follower_id, 1 AS depth FROM followers WHERE follower_id = 1000
	UNION 
	SELECT followers.leader_id, followers.follower_id, depth + 1 
	FROM followers JOIN suggestions ON suggestions.leader_id = followers.follower_id WHERE depth < 3
)
SELECT DISTINCT users.id, users.username, depth FROM suggestions JOIN users ON users.id = suggestions.leader_id WHERE depth > 1 LIMIT 30;
