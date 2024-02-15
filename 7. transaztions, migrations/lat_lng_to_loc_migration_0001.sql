
-- Migrate lan lng to on loc column as point type -- 
-- Should we run in transaction ? --

ALTER TABLE posts 
ADD COLUMN loc POINT;

-- Data migrations
UPDATE posts
SET loc = POINT(lng, lat)
WHERE loc IS NULL;

DROP COLUMN lat;
DROP COLUMN lng;

--- Proper migration for big data --

-- 1. Add loc column --
-- 2. Deploy on server -- 
-- 3. Change the code to write in lat, lng and loc at same time and deploy it with previous --
-- 4. Copy values from lat, lng to loc in NEXT migration after some time --
-- 5. Drop lat, lng --

--- When we use transaction for migration ROW that is affected would be LOCKED until we commit or rollback it ---   
--- So we NEED to use batch updated, especially if we have millions of rows ---