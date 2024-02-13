# BASICS **************************************************************************************************************
SELECT * FROM users;

SELECT username FROM users WHERE id > 5;

SELECT LOWER(contents) FROM comments;

# JOINS **************************************************************************************************************
# For each comment show the contents of the comment and the username of the user who wrote the comment

SELECT contents, username FROM comments JOIN users ON users.id = comments.user_id;

# For each comment, list a content of the comment and url of the photo comment was added to

SELECT contents, url FROM comments JOIN photos ON comments.photo_id = photos.id;

SELECT p.id FROM comments AS c JOIN photos AS p ON c.photo_id = p.id;

# Show each photo url and the username of the poster ADD
SELECT url, username FROM photos AS p LEFT JOIN users AS u ON u.id = p.user_id;


SELECT url, contents FROM comments as c LEFT JOIN photos as p ON c.photo_id = p.id WHERE c.user_id = p.user_id;

# Three ways JOIN 

SELECT url, contents, username FROM comments as c JOIN photos as p ON c.photo_id = p.id JOIN users as u ON u.id = c.user_id AND u.id = p.user_id;

# AGGREGATION AND GROUPING **************************************************************************************************************

SELECT user_id FROM comments GROUP BY user_id;
# Select maximum comment with largest id 
SELECT MAX(id) FROM comments;
SELECT user_id, COUNT(id) FROM comments GROUP BY user_id;
# Count all (NULL values could fail it)
SELECT COUNT(*) FROM comments;
# Find the number of comments for each photo
SELECT photo_id, COUNT(*) FROM comments GROUP BY photo_id;

# FROM -> JOIN -> WHERE -> GROUP -> HAVING

# Find the number of comments for each photo where photo_id is less than 3 and the photo has more than 2 photos
SELECT photo_id, COUNT(*) FROM comments WHERE photo_id < 3 GROUP BY photo_id HAVING COUNT(*) > 2;

# Find the users (user ids) where the user has commented on the first 50 photos and the user added more than 2 comments on those photos
SELECT user_id, COUNT(*) FROM comments WHERE photo_id < 50 GROUP BY user_id HAVING COUNT(*) > 2;