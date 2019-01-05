
CREATE TABLE posts (

	post_id CHAR(39) PRIMARY KEY,
	post_content TEXT NOT NULL,
	comment_count DEFAULT 0,
	created REAL DEFAULT 0,
	image_id CHAR(39)
);

CREATE TABLE comments (
	
	comment_id TEXT PRIMARY KEY,
	comment_post_id TEXT,
	comment_content TEXT,
	created REAL DEFAULT 0,
	image_id CHAR(39),
	FOREIGN KEY(comment_post_id) REFERENCES posts(post_id)
);
