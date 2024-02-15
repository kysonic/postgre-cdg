# Trying to implement likes functionality (posts, comments)

1. Polymorphic associations (anti pattern)

---------------------------------
id | user_id | like_id | type
---------------------------------
1  |    3    |     2    | post 
--------------------------------- 
2  |    2    |     1    | comment

like_id cannot be created as FOREIGN KEY, so developer should define table in SQL by type

2. Polymorphic associations 2

-----------------------------------
id | user_id | post_id | comment_id
-----------------------------------
1  |    3    |     2    |   NULL
-----------------------------------
2  |    2    |   NULL   |     2

Better but, there is a problem with NULL checks and uniqueness of a record

ADD CHECK (
  COALESCE((post_id)::BOOLEAN::INTEGER, 0)
  +
  COALESCE((comment_id)::BOOLEAN::INTEGER, 0)
  = 1
)

3. Different tables 

------------------------
id | user_id | post_id |
-------------------------
1  |    3    |     2    |
-------------------------
2  |    2    |     1    |

--------------------------
id | user_id | comment_id |
---------------------------
1  |    3    |      2     |
---------------------------
2  |    2    |      1     |

To count all likes - just use UNION