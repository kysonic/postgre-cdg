# For each comment show the contents of the comment and the username of the user who wrote the comment

SELECT contents, username FROM comments JOIN users ON users.id = comments.user_id;

# For each comment, list a content of the comment and url of the photo comment was added to

SELECT contents, url FROM comments JOIN photos ON comments.photo_id = photos.id;

SELECT p.id FROM comments AS c JOIN photos AS p ON c.photo_id = p.id;

# Show each photo url and the username of the poster ADD
SELECT url, username FROM photos AS p LEFT JOIN users AS u ON u.id = p.user_id;