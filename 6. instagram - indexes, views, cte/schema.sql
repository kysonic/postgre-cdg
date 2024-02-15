# https://dbdiagram.io/d/Instagram-65cb698bac844320ae0b6df6
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	username VARCHAR(30) NOT NULL,
	bio TEXT,
	avatar VARCHAR(200),
	phone VARCHAR(25) UNIQUE,
	email VARCHAR(100) UNIQUE,
	password VARCHAR(50),
	status VARCHAR(15)
	CHECK(COALESCE(phone, email) IS NOT NULL) # Whether an email or a phone should be not NULL, Error in case if email and phone are NULL
);

CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	url VARCHAR(200) NOT NULL,
	caption VARCHAR(240),
	lat REAL CHECK (lat IS NULL OR (lat <= 90 AND lat >= -90)), 
	lng REAL CHECK (lat IS NULL OR (lat <= 180 AND lat >= -180)),
	
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	contents VARCHAR(240) NOT NULL,
	
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE
);

CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
	comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE
	
	CHECK(
		(COALESCE((post_id)::BOOLEAN::INTEGER, 0)) +
		(COALESCE((comment_id)::BOOLEAN::INTEGER, 0)) 
		= 1
	)
	UNIQUE(user_id, post_id, comment_id)
);

CREATE TABLE photo_tags(
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	x INTEGER,
	y INTEGER,
	
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	UNIQUE(user_id, post_id)
);

CREATE TABLE caption_tags(
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	
	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	UNIQUE(user_id, post_id)
);

CREATE TABLE hashtags (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	title VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE hashtags_posts (
	id SERIAL PRIMARY KEY,
	
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
	hashtag_id INTEGER NOT NULL REFERENCES hashtags(id) ON DELETE CASCADE

  UNIQUE(post_id, hashtag_id)
);

CREATE TABLE followers (
	id SERIAL PRIMARY KEY,
	leader_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	follower_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	
	UNIQUE(leader_id, follower_id),
	CHECK(leader_id <> follower_id)
);

--- INDEXES ----

CREATE INDEX users_username_idx ON users (username);
DROP INDEX users_username_idx;

-- We realized that photo_tags and caption_tags should be combined, so how we always use UNION to work with them, possible solutions ADD

-- 1. Create new table and migrate data 

CREATE TABLE tags (
	id SERIAL PRIMARY KEY,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	x REAL,
	y REAL,

	user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
);

INSERT INTO tags (created_at, updated_at, x, y, user_id, post_id)
SELECT id, created_at, updated_at, x, y, user_id, post_id FROM photo_tags;

INSERT INTO tags (created_at, user_id, post_id)
SELECT id, created_at, user_id, post_id FROM caption_tags;

DROP TABLE photo_tags;
DROP TABLE caption_tags;

-- Downside 1: we can break FOREIGN KEYs
-- Downside 2: code could reference old tables 

-- 2. VIEW (Fake table that aggregate other tables)

CREATE VIEW tags AS (
	SELECT id, created_at, user_id, post_id, 'photo_tag' AS type FROM photo_tags
	UNION ALL
	SELECT id, created_At, user_id, post_id, 'caption_tag' AS type FROM caption_tags
);


-- Common Views for performance sake (recent_post, most viewed posts, etc) -- 

CREATE VIEW recent_posts AS (
	SELECT * FROM posts ORDER BY created_at DESC LIMIT 10
);

-- Update view -- 

CREATE OR REPLACE VIEW recent_posts AS (
		SELECT * FROM posts ORDER BY created_at DESC LIMIT 15
);
-- DELETE --
DROP VIEW recent_posts;

-- Materialized VIEWS - executes not every time but save it (cached) -- 

-- Super slow query must be cached --

CREATE MATERIALIZED VIEW weekly_likes AS (
	SELECT 
	DATE_TRUNC('week', COALESCE(posts.created_at, comments.created_at)) AS week,
	COUNT(posts.id) AS num_posts,
	COUNT(comments.id) AS num_comments
	FROM likes 
	LEFT JOIN posts ON posts.id = likes.post_id 
	LEFT JOIN comments ON comments.id = likes.comment_id 
	GROUP BY week
	ORDER BY week
) WITH DATA;
-- Flush a cache manually -- 
REFRESH MATERIALIZED VIEW weekly_likes;