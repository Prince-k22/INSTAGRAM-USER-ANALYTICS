USE ig_clone;

#  People who have been using the platform for the longest time.
SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;

-- Users who have never posted a single photo on Instagram. (26 RESULTS)
SELECT users.id, username, created_at, image_url
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE image_url IS NULL;


-- User who got most likes on a single photo.
SELECT photos.*,username, count(likes.photo_id) AS total_likes
FROM likes
INNER JOIN photos
ON likes.photo_id = photos.id
INNER JOIN users
ON users.id = photos.user_id
GROUP BY likes.photo_id
ORDER BY total_likes DESC
Limit 1;
    
# All tables
SELECT * FROM photos;
select * from users;
select * from comments;
select * from follows;
select * from likes;
select * from photo_tags;
select * from tags;


-- Hashtag Researching
SELECT tags.*, count(photo_tags.tag_id) AS tag_frequency
FROM photo_tags
INNER JOIN tags
ON photo_tags.tag_id = tags.id
GROUP BY photo_tags.tag_id
ORDER BY tag_frequency DESC
LIMIT 5;

-- Launch AD Campaign
SELECT
dayname(created_at) AS Day,
count(*) AS Registrations
FROM users
GROUP BY Day
ORDER BY Registrations DESC, Day;

-- INVESTOR METRICS
-- Average Posts
WITH metrics AS (
SELECT users.id AS id,
count(photos.id) AS p_id
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
GROUP BY users.id)
-- Average Posts per user calculation.
SELECT
sum(p_id) AS photos,
count(id) AS users,
(sum(p_id)/count(id)) AS avg
FROM metrics;

-- Bots & Fake Accounts (13 RESULTS)
SELECT 
user_id,
username,
count(photo_id) AS photos_liked
FROM likes
INNER JOIN users
ON likes.user_id = users.id
GROUP BY user_id
HAVING photos_liked = MAX(photo_id);
